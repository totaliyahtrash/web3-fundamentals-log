// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "../TestHelpers.sol";
import {DSCEngine} from "../../contracts/defi/DSCEngine.sol";
import {DecentralizedStableCoin} from "../../contracts/defi/DecentralizedStableCoin.sol";
import {ManualToken} from "../../contracts/tokens/ManualToken.sol";
import {MockV3Aggregator} from "../../contracts/mocks/MockV3Aggregator.sol";

/**
 * @title Handler
 * @author totaliyahtrash
 * @notice Bounds inputs and action sequences for Foundry stateful invariant fuzz testing.
 * @dev Prevents fuzzer from wasting cycles on invalid reverts by bounding collateral and mint amounts.
 */
contract Handler is Test {
    DSCEngine internal engine;
    DecentralizedStableCoin internal dsc;
    ManualToken internal weth;
    MockV3Aggregator internal ethUsdPriceFeed;

    uint256 internal constant MAX_DEPOSIT_SIZE = type(uint96).max;
    address[] public usersWithCollateralDeposited;

    constructor(
        DSCEngine _engine,
        DecentralizedStableCoin _dsc,
        ManualToken _weth,
        MockV3Aggregator _ethUsdPriceFeed
    ) {
        engine = _engine;
        dsc = _dsc;
        weth = _weth;
        ethUsdPriceFeed = _ethUsdPriceFeed;
    }

    /**
     * @notice Fuzzer target: deposits random valid amounts of collateral.
     */
    function depositCollateral(uint256 collateralSeed, uint256 amountCollateral) public {
        amountCollateral = bound(amountCollateral, 1, MAX_DEPOSIT_SIZE);
        address sender = _getUserFromSeed(collateralSeed);

        weth.transfer(sender, amountCollateral);

        vm.startPrank(sender);
        weth.approve(address(engine), amountCollateral);
        engine.depositCollateral(address(weth), amountCollateral);
        vm.stopPrank();

        usersWithCollateralDeposited.push(sender);
    }

    /**
     * @notice Fuzzer target: mints DSC within bounded health factors.
     */
    function mintDsc(uint256 userSeed, uint256 amountDscToMint) public {
        if (usersWithCollateralDeposited.length == 0) return;
        address sender = usersWithCollateralDeposited[userSeed % usersWithCollateralDeposited.length];

        (uint256 totalDscMinted, uint256 collateralValueInUsd) = engine.getAccountCollateralValue(sender) > 0
            ? (0, engine.getAccountCollateralValue(sender))
            : (0, 0);

        int256 maxDscToMint = (int256(collateralValueInUsd) / 2) - int256(totalDscMinted);
        if (maxDscToMint <= 0) return;

        amountDscToMint = bound(amountDscToMint, 0, uint256(maxDscToMint));
        if (amountDscToMint == 0) return;

        vm.startPrank(sender);
        engine.mintDsc(amountDscToMint);
        vm.stopPrank();
    }

    // -----------------------------------------------------------------------
    // Internal Helper Functions
    // -----------------------------------------------------------------------
    function bound(uint256 x, uint256 min, uint256 max) internal pure returns (uint256 result) {
        if (min > max) {
            uint256 temp = min;
            min = max;
            max = temp;
        }
        if (x < min) {
            result = min;
        } else if (x > max) {
            result = max;
        } else {
            result = x;
        }
    }

    function _getUserFromSeed(uint256 seed) internal pure returns (address) {
        return address(uint160(uint256(keccak256(abi.encodePacked(seed)))));
    }
}

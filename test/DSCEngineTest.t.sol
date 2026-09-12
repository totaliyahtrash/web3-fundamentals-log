// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "./TestHelpers.sol";
import {DSCEngine, DSCEngine__NeedsMoreThanZero, DSCEngine__BreaksHealthFactor} from "../contracts/defi/DSCEngine.sol";
import {DecentralizedStableCoin} from "../contracts/defi/DecentralizedStableCoin.sol";
import {MockV3Aggregator} from "../contracts/mocks/MockV3Aggregator.sol";
import {ManualToken} from "../contracts/tokens/ManualToken.sol";

/**
 * @title DSCEngineTest
 * @author totaliyahtrash
 * @notice Automated Foundry unit test suite for the Decentralized Stablecoin Protocol (DSCEngine).
 */
contract DSCEngineTest is Test {
    DSCEngine internal engine;
    DecentralizedStableCoin internal dsc;
    MockV3Aggregator internal ethUsdPriceFeed;
    ManualToken internal weth;

    address internal constant USER = address(0x9999);
    uint256 internal constant AMOUNT_COLLATERAL = 10 ether;
    uint256 internal constant ETH_PRICE = 2000e8; // $2,000 / ETH

    address[] internal tokenAddresses;
    address[] internal priceFeedAddresses;

    function setUp() external {
        // 1. Deploy Mock Price Feed & Mock WETH
        ethUsdPriceFeed = new MockV3Aggregator(8, int256(ETH_PRICE));
        weth = new ManualToken("Wrapped Ether", "WETH", 1_000_000);

        tokenAddresses.push(address(weth));
        priceFeedAddresses.push(address(ethUsdPriceFeed));

        // 2. Deploy Engine & DSC
        engine = new DSCEngine(tokenAddresses, priceFeedAddresses);
        dsc = new DecentralizedStableCoin(address(engine));

        // 3. Fund user with WETH
        weth.transfer(USER, AMOUNT_COLLATERAL);
    }

    /* -------------------------------------------------------------------------- */
    /*                               PRICE TESTS                                  */
    /* -------------------------------------------------------------------------- */

    function testGetUsdValue() public view {
        uint256 ethAmount = 15 ether;
        // 15 ETH * $2,000/ETH = $30,000
        uint256 expectedUsd = 30000e18;
        uint256 actualUsd = engine.getUsdValue(address(weth), ethAmount);
        assertEq(actualUsd, expectedUsd, "USD value calculation mismatch");
    }

    function testGetTokenAmountFromUsd() public view {
        uint256 usdAmount = 100 ether; // $100
        // $100 / $2,000 = 0.05 ETH
        uint256 expectedWeth = 0.05 ether;
        uint256 actualWeth = engine.getTokenAmountFromUsd(address(weth), usdAmount);
        assertEq(actualWeth, expectedWeth, "Token amount from USD calculation mismatch");
    }

    /* -------------------------------------------------------------------------- */
    /*                         DEPOSIT COLLATERAL TESTS                           */
    /* -------------------------------------------------------------------------- */

    function testRevertsIfCollateralZero() public {
        vm.prank(USER);
        vm.expectRevert(abi.encodeWithSelector(DSCEngine__NeedsMoreThanZero.selector));
        engine.depositCollateral(address(weth), 0);
    }

    function testCanDepositCollateralAndGetAccountInfo() public {
        vm.prank(USER);
        weth.approve(address(engine), AMOUNT_COLLATERAL);

        vm.prank(USER);
        engine.depositCollateral(address(weth), AMOUNT_COLLATERAL);

        uint256 deposited = engine.getCollateralDeposited(USER, address(weth));
        assertEq(deposited, AMOUNT_COLLATERAL, "Collateral should be recorded in engine");

        // 10 ETH * $2,000 = $20,000
        uint256 totalCollateralValue = engine.getAccountCollateralValue(USER);
        assertEq(totalCollateralValue, 20000e18, "Collateral value in USD must be $20k");
    }

    /* -------------------------------------------------------------------------- */
    /*                           HEALTH FACTOR TESTS                              */
    /* -------------------------------------------------------------------------- */

    function testRevertIfMintBreaksHealthFactor() public {
        // User deposits 1 ETH ($2,000 value).
        // 50% liquidation threshold allows max $1,000 DSC mint.
        // If user tries to mint $1,001 DSC -> Health factor < 1.0 -> Revert!
        vm.prank(USER);
        weth.approve(address(engine), 1 ether);

        vm.prank(USER);
        engine.depositCollateral(address(weth), 1 ether);

        vm.prank(USER);
        vm.expectRevert();
        engine.mintDsc(1001e18);
    }

    function testCanMintDscWithinSafeHealthFactor() public {
        // Deposit 10 ETH ($20,000). Mint $5,000 DSC (400% collateralized, Health Factor = 2.0).
        vm.prank(USER);
        weth.approve(address(engine), AMOUNT_COLLATERAL);

        vm.prank(USER);
        engine.depositCollateral(address(weth), AMOUNT_COLLATERAL);

        vm.prank(USER);
        engine.mintDsc(5000e18);

        uint256 healthFactor = engine.getHealthFactor(USER);
        // HF = ($20,000 * 0.5) / $5,000 = 2.0 (2e18)
        assertEq(healthFactor, 2e18, "Health factor should be exactly 2.0");
    }
}

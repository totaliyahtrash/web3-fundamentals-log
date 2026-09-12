// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "../TestHelpers.sol";
import {DSCEngine} from "../../contracts/defi/DSCEngine.sol";
import {DecentralizedStableCoin} from "../../contracts/defi/DecentralizedStableCoin.sol";
import {MockV3Aggregator} from "../../contracts/mocks/MockV3Aggregator.sol";
import {ManualToken} from "../../contracts/tokens/ManualToken.sol";
import {Handler} from "./Handler.sol";

/**
 * @title InvariantsTest
 * @author totaliyahtrash
 * @notice Stateful Invariant Fuzz Test Suite for the DeFi Stablecoin Protocol.
 * @dev Verifies that core protocol invariants NEVER break regardless of user interaction ordering.
 */
contract InvariantsTest is Test {
    DSCEngine internal engine;
    DecentralizedStableCoin internal dsc;
    MockV3Aggregator internal ethUsdPriceFeed;
    ManualToken internal weth;
    Handler internal handler;

    address[] internal tokenAddresses;
    address[] internal priceFeedAddresses;

    function setUp() external {
        // 1. Deploy Mocks
        ethUsdPriceFeed = new MockV3Aggregator(8, 2000e8); // $2,000 / ETH
        weth = new ManualToken("Wrapped Ether", "WETH", 10_000_000);

        tokenAddresses.push(address(weth));
        priceFeedAddresses.push(address(ethUsdPriceFeed));

        // 2. Deploy Engine & DSC
        engine = new DSCEngine(tokenAddresses, priceFeedAddresses);
        dsc = new DecentralizedStableCoin(address(engine));

        // 3. Deploy Handler to bound randomized actions
        handler = new Handler(engine, dsc, weth, ethUsdPriceFeed);
    }

    /**
     * @notice Core System Invariant:
     * Total Collateral Value in USD must ALWAYS be greater than or equal to Total DSC Supply minted!
     */
    function invariant_protocolMustHaveMoreValueThanTotalSupply() public view {
        uint256 totalWethDeposited = weth.balanceOf(address(engine));
        uint256 wethValueInUsd = engine.getUsdValue(address(weth), totalWethDeposited);

        uint256 totalDscSupply = dsc.totalSupply();

        // The invariant: Protocol value must always back outstanding debt!
        assertTrue(
            wethValueInUsd >= totalDscSupply,
            "CRITICAL INVARIANT VIOLATION: Protocol is insolvent (Collateral < Total Debt)"
        );
    }

    /**
     * @notice Fuzzer target getter functions should never revert.
     */
    function invariant_gettersShouldNotRevert() public view {
        engine.getAccountCollateralValue(address(this));
    }
}

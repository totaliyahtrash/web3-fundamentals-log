// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "./TestHelpers.sol";
import {CPAMM} from "../contracts/defi/CPAMM.sol";
import {ManualToken} from "../contracts/tokens/ManualToken.sol";

/**
 * @title CPAMMTest
 * @author totaliyahtrash
 * @notice Automated Foundry unit test suite for Constant Product AMM DEX protocol.
 */
contract CPAMMTest is Test {
    CPAMM internal amm;
    ManualToken internal token0;
    ManualToken internal token1;

    address internal constant LP_PROVIDER = address(0xAAAA);
    address internal constant TRADER = address(0xBBBB);

    function setUp() external {
        // Deploy two test tokens
        token0 = new ManualToken("Token Zero", "TK0", 1_000_000);
        token1 = new ManualToken("Token One", "TK1", 1_000_000);

        amm = new CPAMM(address(token0), address(token1));

        // Fund LP Provider
        token0.transfer(LP_PROVIDER, 10_000 * 1e18);
        token1.transfer(LP_PROVIDER, 10_000 * 1e18);

        // Fund Trader
        token0.transfer(TRADER, 1_000 * 1e18);
        token1.transfer(TRADER, 1_000 * 1e18);
    }

    function testAddInitialLiquidity() public {
        vm.startPrank(LP_PROVIDER);
        token0.approve(address(amm), 1000 * 1e18);
        token1.approve(address(amm), 1000 * 1e18);

        uint256 shares = amm.addLiquidity(1000 * 1e18, 1000 * 1e18);
        vm.stopPrank();

        // sqrt(1000 * 1000) = 1000
        assertEq(shares, 1000 * 1e18, "Shares minted must match geometric mean");
        assertEq(amm.reserve0(), 1000 * 1e18, "Reserve0 must match");
        assertEq(amm.reserve1(), 1000 * 1e18, "Reserve1 must match");
    }

    function testSwapToken0ForToken1() public {
        // 1. LP adds 1,000 of Token0 and 1,000 of Token1
        vm.startPrank(LP_PROVIDER);
        token0.approve(address(amm), 1000 * 1e18);
        token1.approve(address(amm), 1000 * 1e18);
        amm.addLiquidity(1000 * 1e18, 1000 * 1e18);
        vm.stopPrank();

        // 2. Trader swaps 100 Token0 for Token1
        vm.startPrank(TRADER);
        token0.approve(address(amm), 100 * 1e18);
        uint256 amountOut = amm.swap(address(token0), 100 * 1e18);
        vm.stopPrank();

        // Output calculation: (1000 * 99.7) / (1000 + 99.7) ~ 90.66
        assertTrue(amountOut > 90 * 1e18, "Amount out should be ~90.6 Token1");
        assertEq(token1.balanceOf(TRADER), 1_000 * 1e18 + amountOut, "Trader received Token1");
    }

    function testRemoveLiquidity() public {
        vm.startPrank(LP_PROVIDER);
        token0.approve(address(amm), 1000 * 1e18);
        token1.approve(address(amm), 1000 * 1e18);
        uint256 shares = amm.addLiquidity(1000 * 1e18, 1000 * 1e18);

        // Remove 50% of shares
        (uint256 amount0, uint256 amount1) = amm.removeLiquidity(shares / 2);
        vm.stopPrank();

        assertEq(amount0, 500 * 1e18, "Should receive 50% of Token0 reserve");
        assertEq(amount1, 500 * 1e18, "Should receive 50% of Token1 reserve");
    }
}

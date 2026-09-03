// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "./TestHelpers.sol";
import {
    ManualToken,
    Token__InsufficientBalance,
    Token__AllowanceExceeded,
    Token__ZeroAddressNotAllowed
} from "../contracts/tokens/ManualToken.sol";

/**
 * @title ManualTokenTest
 * @author totaliyahtrash
 * @notice Automated unit test suite verifying ERC-20 token standard compliance.
 */
contract ManualTokenTest is Test {
    ManualToken internal token;

    address internal constant ALICE = address(0xAAAA);
    address internal constant BOB = address(0xBBBB);

    uint256 internal constant INITIAL_SUPPLY = 1_000_000; // 1M tokens

    function setUp() external {
        // Deploy token with initial supply minted to this contract
        token = new ManualToken("Web3 Builder Token", "W3B", INITIAL_SUPPLY);
    }

    function testTokenMetadata() public view {
        assertEq(token.decimals(), 18, "Decimals must be 18");
        assertEq(token.totalSupply(), INITIAL_SUPPLY * 1e18, "Total supply must match");
    }

    function testDirectTransfer() public {
        uint256 transferAmount = 500 * 1e18;
        
        token.transfer(ALICE, transferAmount);

        assertEq(token.balanceOf(ALICE), transferAmount, "Alice should have received tokens");
        assertEq(
            token.balanceOf(address(this)),
            (INITIAL_SUPPLY * 1e18) - transferAmount,
            "Deployer balance should be deducted"
        );
    }

    function testTransferFailsOnInsufficientBalance() public {
        vm.prank(BOB); // Bob has 0 tokens
        vm.expectRevert(
            abi.encodeWithSelector(
                Token__InsufficientBalance.selector,
                BOB,
                0,
                100 * 1e18
            )
        );
        token.transfer(ALICE, 100 * 1e18);
    }

    function testApproveAndTransferFrom() public {
        uint256 approvedAmount = 1000 * 1e18;
        uint256 spentAmount = 400 * 1e18;

        // 1. Owner approves Alice to spend 1000 tokens
        token.approve(ALICE, approvedAmount);
        assertEq(token.allowance(address(this), ALICE), approvedAmount, "Allowance set");

        // 2. Alice transfers 400 tokens from Owner to Bob
        vm.prank(ALICE);
        token.transferFrom(address(this), BOB, spentAmount);

        // 3. Assert balances and remaining allowance
        assertEq(token.balanceOf(BOB), spentAmount, "Bob received tokens");
        assertEq(
            token.allowance(address(this), ALICE),
            approvedAmount - spentAmount,
            "Remaining allowance updated"
        );
    }

    function testTransferFromFailsIfAllowanceExceeded() public {
        token.approve(ALICE, 100 * 1e18);

        vm.prank(ALICE);
        vm.expectRevert(
            abi.encodeWithSelector(
                Token__AllowanceExceeded.selector,
                ALICE,
                100 * 1e18,
                200 * 1e18
            )
        );
        token.transferFrom(address(this), BOB, 200 * 1e18);
    }
}

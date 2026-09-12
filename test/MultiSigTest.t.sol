// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "./TestHelpers.sol";
import {
    MultiSigWallet,
    MultiSig__CannotExecuteNotEnoughConfirmations,
    MultiSig__OnlyOwner,
    MultiSig__TxAlreadyExecuted
} from "../contracts/multisig/MultiSigWallet.sol";

/**
 * @title MultiSigTest
 * @author totaliyahtrash
 * @notice Automated Foundry unit test suite for M-of-N MultiSig treasury wallet.
 */
contract MultiSigTest is Test {
    MultiSigWallet internal wallet;

    address internal constant OWNER1 = address(0x1111);
    address internal constant OWNER2 = address(0x2222);
    address internal constant OWNER3 = address(0x3333);
    address internal constant NON_OWNER = address(0x9999);
    address internal constant RECIPIENT = address(0xAAAA);

    address[] internal owners;

    function setUp() external {
        owners = new address[](3);
        owners[0] = OWNER1;
        owners[1] = OWNER2;
        owners[2] = OWNER3;

        // 2-of-3 MultiSig configuration
        wallet = new MultiSigWallet(owners, 2);

        // Fund wallet with 10 ETH
        vm.deal(address(wallet), 10 ether);
    }

    function testMultiSigInitializesProperly() public view {
        assertEq(wallet.i_numConfirmationsRequired(), 2, "Threshold must be 2");
        assertEq(wallet.s_isOwner(OWNER1), true, "Owner1 must be registered");
        assertEq(wallet.s_isOwner(NON_OWNER), false, "Non-owner must not be registered");
    }

    function testSubmitAndConfirmFlow() public {
        // 1. Owner 1 proposes 1 ETH transfer to RECIPIENT
        vm.prank(OWNER1);
        uint256 txIndex = wallet.submitTransaction(RECIPIENT, 1 ether, "");
        assertEq(txIndex, 0, "First tx index is 0");

        // 2. Owner 1 confirms
        vm.prank(OWNER1);
        wallet.confirmTransaction(txIndex);

        // 3. Attempt execution with only 1 confirmation (Threshold is 2) -> must revert
        vm.prank(OWNER1);
        vm.expectRevert(abi.encodeWithSelector(MultiSig__CannotExecuteNotEnoughConfirmations.selector));
        wallet.executeTransaction(txIndex);

        // 4. Owner 2 confirms (now 2 confirmations)
        vm.prank(OWNER2);
        wallet.confirmTransaction(txIndex);

        // 5. Execute transaction
        uint256 startingRecipientBalance = RECIPIENT.balance;
        vm.prank(OWNER1);
        wallet.executeTransaction(txIndex);

        assertEq(RECIPIENT.balance, startingRecipientBalance + 1 ether, "Recipient received 1 ETH");

        // 6. Cannot execute already executed tx
        vm.prank(OWNER1);
        vm.expectRevert(abi.encodeWithSelector(MultiSig__TxAlreadyExecuted.selector));
        wallet.executeTransaction(txIndex);
    }

    function testNonOwnerCannotSubmitOrConfirm() public {
        vm.prank(NON_OWNER);
        vm.expectRevert(abi.encodeWithSelector(MultiSig__OnlyOwner.selector));
        wallet.submitTransaction(RECIPIENT, 1 ether, "");
    }
}

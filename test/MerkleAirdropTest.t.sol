// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "./TestHelpers.sol";
import {
    MerkleAirdrop,
    MerkleAirdrop__AlreadyClaimed,
    MerkleAirdrop__InvalidProof
} from "../contracts/airdrops/MerkleAirdrop.sol";
import {ManualToken} from "../contracts/tokens/ManualToken.sol";

/**
 * @title MerkleAirdropTest
 * @author totaliyahtrash
 * @notice Automated Foundry unit test suite for cryptographic Merkle Tree airdrop distributions.
 */
contract MerkleAirdropTest is Test {
    MerkleAirdrop internal airdrop;
    ManualToken internal token;

    address internal constant ALICE = address(0xAAAA);
    address internal constant BOB = address(0xBBBB);
    address internal constant ATTACKER = address(0xDEAD);

    uint256 internal constant AMOUNT_TO_CLAIM = 25 * 1e18;

    bytes32 internal root;
    bytes32 internal leafAlice;
    bytes32 internal leafBob;
    bytes32[] internal proofAlice;

    function setUp() external {
        // 1. Deploy Airdrop ERC-20 Token
        token = new ManualToken("Airdrop Token", "AIR", 1_000_000);

        // 2. Generate double-hashed leaf nodes
        leafAlice = keccak256(bytes.concat(keccak256(abi.encode(ALICE, AMOUNT_TO_CLAIM))));
        leafBob = keccak256(bytes.concat(keccak256(abi.encode(BOB, AMOUNT_TO_CLAIM))));

        // 3. Compute Merkle Root with commutative ordering
        if (leafAlice <= leafBob) {
            root = keccak256(abi.encodePacked(leafAlice, leafBob));
        } else {
            root = keccak256(abi.encodePacked(leafBob, leafAlice));
        }

        // 4. Deploy MerkleAirdrop contract with Root
        airdrop = new MerkleAirdrop(root, address(token));

        // 5. Fund Airdrop contract with tokens
        token.transfer(address(airdrop), 10_000 * 1e18);

        // 6. Construct Alice's proof (sibling is leafBob)
        proofAlice = new bytes32[](1);
        proofAlice[0] = leafBob;
    }

    function testAliceCanClaimWithValidProof() public {
        uint256 startingBalance = token.balanceOf(ALICE);
        assertEq(startingBalance, 0, "Alice initial balance should be 0");

        // Alice claims her airdrop
        vm.prank(ALICE);
        airdrop.claim(ALICE, AMOUNT_TO_CLAIM, proofAlice);

        uint256 endingBalance = token.balanceOf(ALICE);
        assertEq(endingBalance, AMOUNT_TO_CLAIM, "Alice should have received 25 tokens");
        assertTrue(airdrop.hasClaimed(ALICE), "Alice claim status must be true");
    }

    function testAliceCannotClaimTwice() public {
        vm.prank(ALICE);
        airdrop.claim(ALICE, AMOUNT_TO_CLAIM, proofAlice);

        // Second claim attempt should revert
        vm.prank(ALICE);
        vm.expectRevert(abi.encodeWithSelector(MerkleAirdrop__AlreadyClaimed.selector));
        airdrop.claim(ALICE, AMOUNT_TO_CLAIM, proofAlice);
    }

    function testAttackerCannotClaimWithFakeProof() public {
        bytes32[] memory fakeProof = new bytes32[](1);
        fakeProof[0] = bytes32(uint256(0x9999));

        vm.prank(ATTACKER);
        vm.expectRevert(abi.encodeWithSelector(MerkleAirdrop__InvalidProof.selector));
        airdrop.claim(ATTACKER, AMOUNT_TO_CLAIM, fakeProof);
    }
}

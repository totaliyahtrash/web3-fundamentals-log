// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ManualToken} from "../tokens/ManualToken.sol";
import {MerkleProof} from "./MerkleProof.sol";

// -----------------------------------------------------------------------
// Custom Errors
// -----------------------------------------------------------------------
error MerkleAirdrop__AlreadyClaimed();
error MerkleAirdrop__InvalidProof();
error MerkleAirdrop__TransferFailed();

/**
 * @title MerkleAirdrop
 * @author totaliyahtrash
 * @notice Highly gas-efficient token airdrop distribution contract using Merkle Trees.
 * @dev Stores only a 32-byte Merkle root on-chain (O(1) storage), verifying user claims in O(log N) operations.
 */
contract MerkleAirdrop {
    // Reusable ERC-20 token being airdropped
    ManualToken public immutable i_airdropToken;

    // The 32-byte Merkle Root representing the full off-chain whitelist
    bytes32 public immutable i_merkleRoot;

    // Tracks which addresses have already claimed their allocation
    mapping(address => bool) private s_hasClaimed;

    event Claimed(address indexed account, uint256 amount);

    constructor(bytes32 merkleRoot, address airdropToken) {
        i_merkleRoot = merkleRoot;
        i_airdropToken = ManualToken(airdropToken);
    }

    /**
     * @notice Claims airdropped tokens by submitting a valid cryptographic Merkle proof.
     * @param account The address of the claiming recipient.
     * @param amount The token allocation amount assigned to this recipient.
     * @param merkleProof Array of sibling 32-byte hashes proving membership in the Merkle tree.
     */
    function claim(
        address account,
        uint256 amount,
        bytes32[] calldata merkleProof
    ) external {
        if (s_hasClaimed[account]) {
            revert MerkleAirdrop__AlreadyClaimed();
        }

        // Double-hash leaf construction prevents second preimage attacks:
        // leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))))
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));

        if (!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)) {
            revert MerkleAirdrop__InvalidProof();
        }

        s_hasClaimed[account] = true;
        emit Claimed(account, amount);

        bool success = i_airdropToken.transfer(account, amount);
        if (!success) {
            revert MerkleAirdrop__TransferFailed();
        }
    }

    function hasClaimed(address account) external view returns (bool) {
        return s_hasClaimed[account];
    }

    function getMerkleRoot() external view returns (bytes32) {
        return i_merkleRoot;
    }

    function getAirdropToken() external view returns (address) {
        return address(i_airdropToken);
    }
}

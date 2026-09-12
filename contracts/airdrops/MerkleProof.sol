// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title MerkleProof
 * @author totaliyahtrash
 * @notice Pure cryptographic helper library to verify Merkle Tree membership proofs on-chain.
 * @dev Reconstructs root hash from leaf and sibling proof hashes using commutative sorted pairs.
 */
library MerkleProof {
    /**
     * @notice Verifies a Merkle proof proving that `leaf` exists in the tree with root `root`.
     * @param proof Array of sibling hashes along the branch path from leaf to root.
     * @param root The 32-byte Merkle root stored on-chain.
     * @param leaf The leaf hash to verify.
     * @return True if the computed hash matches the expected root.
     */
    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf
    ) internal pure returns (bool) {
        bytes32 computedHash = leaf;

        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];

            // Commutative sorted pair hashing prevents second-preimage collision attacks
            if (computedHash <= proofElement) {
                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
            } else {
                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
            }
        }

        return computedHash == root;
    }
}

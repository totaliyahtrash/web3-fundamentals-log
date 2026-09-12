// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// -----------------------------------------------------------------------
// Custom Errors
// -----------------------------------------------------------------------
error BasicNft__TokenDoesNotExist();
error BasicNft__ZeroAddressNotAllowed();

/**
 * @title BasicNft
 * @author totaliyahtrash
 * @notice Clean, gas-efficient ERC-721 standard NFT contract written from scratch.
 * @dev Manages unique non-fungible token IDs, owner mappings, and token URI lookups.
 */
contract BasicNft {
    string public name;
    string public symbol;
    uint256 private s_tokenCounter;

    // Token ID => Owner address
    mapping(uint256 => address) private s_owners;

    // Owner address => Token balance
    mapping(address => uint256) private s_balances;

    // Token ID => Token URI (e.g. ipfs://...)
    mapping(uint256 => string) private s_tokenURIs;

    // Token ID => Approved operator
    mapping(uint256 => address) private s_tokenApprovals;

    // -----------------------------------------------------------------------
    // ERC-721 Standard Events
    // -----------------------------------------------------------------------
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        s_tokenCounter = 0;
    }

    /**
     * @notice Mints a new NFT with a given token URI.
     * @param tokenUri IPFS or HTTP metadata URI.
     */
    function mintNft(string memory tokenUri) public returns (uint256) {
        uint256 newTokenId = s_tokenCounter;
        s_owners[newTokenId] = msg.sender;
        s_balances[msg.sender] += 1;
        s_tokenURIs[newTokenId] = tokenUri;

        emit Transfer(address(0), msg.sender, newTokenId);
        s_tokenCounter++;
        return newTokenId;
    }

    /**
     * @notice Transfers an NFT from one address to another.
     */
    function transferFrom(address from, address to, uint256 tokenId) public {
        if (to == address(0)) revert BasicNft__ZeroAddressNotAllowed();
        if (s_owners[tokenId] != from) revert BasicNft__TokenDoesNotExist();
        if (msg.sender != from && msg.sender != s_tokenApprovals[tokenId]) {
            revert("Not authorized");
        }

        s_balances[from] -= 1;
        s_balances[to] += 1;
        s_owners[tokenId] = to;
        delete s_tokenApprovals[tokenId];

        emit Transfer(from, to, tokenId);
    }

    function approve(address to, uint256 tokenId) public {
        address owner = s_owners[tokenId];
        if (msg.sender != owner) revert("Not owner");
        s_tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    // -----------------------------------------------------------------------
    // View Functions
    // -----------------------------------------------------------------------
    function tokenURI(uint256 tokenId) public view virtual returns (string memory) {
        if (s_owners[tokenId] == address(0)) revert BasicNft__TokenDoesNotExist();
        return s_tokenURIs[tokenId];
    }

    function balanceOf(address owner) public view returns (uint256) {
        return s_balances[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = s_owners[tokenId];
        if (owner == address(0)) revert BasicNft__TokenDoesNotExist();
        return owner;
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}

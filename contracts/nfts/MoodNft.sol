// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Base64} from "./Base64.sol";
import {BasicNft} from "./BasicNft.sol";

error MoodNft__CantFlipMoodIfNotOwner();

/**
 * @title MoodNft (Dynamic On-Chain SVG NFT)
 * @author totaliyahtrash
 * @notice Fully on-chain NFT whose artwork and metadata are generated entirely by EVM smart contract logic.
 * @dev Encodes SVG graphics and JSON metadata directly into Base64 URI strings without external IPFS dependencies.
 */
contract MoodNft is BasicNft {
    enum Mood {
        HAPPY,
        SAD
    }

    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;

    mapping(uint256 => Mood) private s_tokenIdToMood;

    event CreatedNFT(uint256 indexed tokenId);

    constructor(
        string memory sadSvgImageUri,
        string memory happySvgImageUri
    ) BasicNft("Mood NFT", "MOOD") {
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
    }

    /**
     * @notice Converts an SVG string into a base64 encoded data URI.
     */
    function svgToImageURI(string memory svg) public pure returns (string memory) {
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string(abi.encodePacked("data:image/svg+xml;base64,", svgBase64Encoded));
    }

    /**
     * @notice Mints a new Mood NFT, defaulting to HAPPY state.
     */
    function mintMoodNft() public returns (uint256) {
        uint256 tokenId = mintNft("");
        s_tokenIdToMood[tokenId] = Mood.HAPPY;
        emit CreatedNFT(tokenId);
        return tokenId;
    }

    /**
     * @notice Flips the NFT state between HAPPY and SAD.
     * @dev Restricted to the owner of the specific token ID.
     */
    function flipMood(uint256 tokenId) public {
        if (ownerOf(tokenId) != msg.sender) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }

        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    /**
     * @notice Dynamically constructs the on-chain Base64 JSON metadata payload.
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        // Validate token exists
        ownerOf(tokenId);

        string memory imageURI = s_happySvgImageUri;
        if (s_tokenIdToMood[tokenId] == Mood.SAD) {
            imageURI = s_sadSvgImageUri;
        }

        // Construct on-chain JSON metadata
        bytes memory jsonMetadata = abi.encodePacked(
            '{"name":"',
            name,
            '", "description":"An on-chain dynamic NFT reflecting the mood of its owner.", ',
            '"attributes": [{"trait_type": "Mood", "value": "',
            s_tokenIdToMood[tokenId] == Mood.HAPPY ? "Happy" : "Sad",
            '"}], "image":"',
            imageURI,
            '"}'
        );

        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(jsonMetadata)
            )
        );
    }

    function getMood(uint256 tokenId) public view returns (Mood) {
        return s_tokenIdToMood[tokenId];
    }
}

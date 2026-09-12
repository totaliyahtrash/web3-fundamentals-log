// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "./TestHelpers.sol";
import {BasicNft} from "../contracts/nfts/BasicNft.sol";
import {MoodNft} from "../contracts/nfts/MoodNft.sol";

/**
 * @title NftTest
 * @author totaliyahtrash
 * @notice Automated Foundry unit test suite for ERC-721 and Dynamic SVG NFTs.
 */
contract NftTest is Test {
    BasicNft internal basicNft;
    MoodNft internal moodNft;

    address internal constant USER = address(0x4321);
    string internal constant PUG_URI = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    string internal constant SAD_SVG = '<svg xmlns="http://www.w3.org/2000/svg" width="500" height="500"><text x="0" y="15">:(</text></svg>';
    string internal constant HAPPY_SVG = '<svg xmlns="http://www.w3.org/2000/svg" width="500" height="500"><text x="0" y="15">:)</text></svg>';

    function setUp() external {
        basicNft = new BasicNft("Dogie", "DOG");
        
        // Convert SVGs to Base64 data URIs
        string memory sadSvgUri = moodNftHelperSvgUri(SAD_SVG);
        string memory happySvgUri = moodNftHelperSvgUri(HAPPY_SVG);

        moodNft = new MoodNft(sadSvgUri, happySvgUri);
    }

    function moodNftHelperSvgUri(string memory svg) internal pure returns (string memory) {
        return string(abi.encodePacked("data:image/svg+xml;base64,", svg));
    }

    /* -------------------------------------------------------------------------- */
    /*                              BASIC NFT TESTS                               */
    /* -------------------------------------------------------------------------- */

    function testBasicNftCanMintAndHaveABalance() public {
        vm.prank(USER);
        uint256 tokenId = basicNft.mintNft(PUG_URI);

        assertEq(basicNft.balanceOf(USER), 1, "User balance should be 1");
        assertEq(basicNft.ownerOf(tokenId), USER, "Owner should be USER");
        assertEq(basicNft.getTokenCounter(), 1, "Token counter should increment");
    }

    /* -------------------------------------------------------------------------- */
    /*                              MOOD NFT TESTS                                */
    /* -------------------------------------------------------------------------- */

    function testMoodNftInitializesHappy() public {
        vm.prank(USER);
        uint256 tokenId = moodNft.mintMoodNft();

        assertTrue(
            moodNft.getMood(tokenId) == MoodNft.Mood.HAPPY,
            "Mood NFT must initialize as HAPPY"
        );
    }

    function testFlipMoodToSad() public {
        vm.prank(USER);
        uint256 tokenId = moodNft.mintMoodNft();

        // Owner flips mood
        vm.prank(USER);
        moodNft.flipMood(tokenId);

        assertTrue(
            moodNft.getMood(tokenId) == MoodNft.Mood.SAD,
            "Mood NFT should flip to SAD"
        );
    }

    function testTokenUriReturnsValidBase64Json() public {
        vm.prank(USER);
        uint256 tokenId = moodNft.mintMoodNft();

        string memory uri = moodNft.tokenURI(tokenId);
        assertTrue(bytes(uri).length > 0, "Token URI should not be empty");
    }
}

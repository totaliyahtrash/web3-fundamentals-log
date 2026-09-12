// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, Vm} from "../test/TestHelpers.sol";
import {FundMe} from "../contracts/fundme/FundMe.sol";
import {MockV3Aggregator} from "../contracts/mocks/MockV3Aggregator.sol";

/**
 * @title DeployFundMe
 * @author totaliyahtrash
 * @notice Automated deployment script for FundMe.sol using Foundry broadcast cheatcodes.
 */
contract DeployFundMe is Test {
    // Official Chainlink Sepolia ETH / USD Price Feed
    address internal constant SEPOLIA_PRICE_FEED = 0x694AA1769357215DE4FAC081bf1f309aDC325306;

    function run() external returns (FundMe, address) {
        address targetPriceFeed;

        // If deploying on a local Anvil chain (chainid 31337), deploy a mock aggregator first
        if (block.chainid == 31337) {
            vm.startBroadcast();
            MockV3Aggregator mockFeed = new MockV3Aggregator(8, 3000e8);
            targetPriceFeed = address(mockFeed);
            vm.stopBroadcast();
        } else {
            // Live Sepolia testnet or other network
            targetPriceFeed = SEPOLIA_PRICE_FEED;
        }

        vm.startBroadcast();
        FundMe fundMe = new FundMe(targetPriceFeed);
        vm.stopBroadcast();

        return (fundMe, targetPriceFeed);
    }
}

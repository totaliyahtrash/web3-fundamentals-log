// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title AggregatorV3Interface
 * @notice Minimal interface for Chainlink Price Feeds.
 * @dev Allows querying real-world decentralized asset prices without importing full NPM package.
 */
interface AggregatorV3Interface {
    function decimals() external view returns (uint8);
    function description() external view returns (string memory);
    function version() external view returns (uint256);
    function getRoundData(
        uint80 _roundId
    )
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}

/**
 * @title PriceConverter
 * @author totaliyahtrash
 * @notice A reusable Solidity library for converting ETH amounts to USD using Chainlink oracles.
 * @dev Libraries are embedded into contract bytecode if functions are internal, avoiding delegatecalls.
 */
library PriceConverter {
    /**
     * @notice Fetches the latest ETH/USD price from a Chainlink Price Feed aggregator.
     * @param priceFeed The Chainlink aggregator contract interface.
     * @return Current price of 1 ETH in USD with 18 decimal places.
     */
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        // Sepolia ETH / USD Feed Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        (, int256 price, , , ) = priceFeed.latestRoundData();
        
        // Chainlink ETH/USD feed returns 8 decimals (e.g., 3000_00000000 for $3,000)
        // Convert to 18 decimals (Wei precision): price * 10^10
        return uint256(price) * 1e10;
    }

    /**
     * @notice Converts an incoming ETH amount (in Wei) to its equivalent USD value (with 18 decimals).
     * @param ethAmount Amount of ETH in Wei (18 decimals).
     * @param priceFeed The Chainlink aggregator contract interface.
     * @return USD value of the provided ETH amount (18 decimals).
     */
    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        
        // Math: (ethAmount in Wei * ethPrice with 18 decimals) / 1e18
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}

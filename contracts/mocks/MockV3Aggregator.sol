// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title MockV3Aggregator
 * @author totaliyahtrash
 * @notice Mock Chainlink Price Feed aggregator for local testing and Remix deployment.
 * @dev Emulates Chainlink AggregatorV3Interface returns for testing price conversion logic.
 */
contract MockV3Aggregator {
    uint8 public decimals;
    int256 public latestAnswer;
    uint256 public latestTimestamp;
    uint256 public latestRound;

    mapping(uint80 => int256) public answers;
    mapping(uint80 => uint256) public timestamps;

    constructor(uint8 _decimals, int256 _initialAnswer) {
        decimals = _decimals;
        updateAnswer(_initialAnswer);
    }

    function updateAnswer(int256 _answer) public {
        latestAnswer = _answer;
        latestTimestamp = block.timestamp;
        latestRound++;
        answers[uint80(latestRound)] = _answer;
        timestamps[uint80(latestRound)] = block.timestamp;
    }

    function updateRoundData(
        uint80 _roundId,
        int256 _answer,
        uint256 _timestamp,
        uint256 _startedAt
    ) public {
        latestRound = _roundId;
        latestAnswer = _answer;
        latestTimestamp = _timestamp;
        answers[_roundId] = _answer;
        timestamps[_roundId] = _timestamp;
    }

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
        )
    {
        return (_roundId, answers[_roundId], timestamps[_roundId], timestamps[_roundId], _roundId);
    }

    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        return (
            uint80(latestRound),
            latestAnswer,
            latestTimestamp,
            latestTimestamp,
            uint80(latestRound)
        );
    }

    function description() external pure returns (string memory) {
        return "v0.8/tests/MockV3Aggregator.sol";
    }

    function version() external pure returns (uint256) {
        return 4;
    }
}

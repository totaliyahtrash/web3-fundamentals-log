// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title IVRFConsumer
 * @notice Callback interface for Chainlink VRF Consumers.
 */
interface IVRFConsumer {
    function rawFulfillRandomWords(uint256 requestId, uint256[] memory randomWords) external;
}

/**
 * @title MockVRFCoordinator
 * @author totaliyahtrash
 * @notice Mock Chainlink VRF Coordinator for local Foundry testing and simulation.
 * @dev Allows test scripts to deterministically fulfill random word requests without paying LINK fees.
 */
contract MockVRFCoordinator {
    uint256 private s_nextRequestId = 1;

    struct Request {
        address consumer;
        uint32 numWords;
    }

    mapping(uint256 => Request) public s_requests;

    event RandomWordsRequested(
        bytes32 indexed keyHash,
        uint256 requestId,
        uint256 subId,
        uint16 minimumRequestConfirmations,
        uint32 callbackGasLimit,
        uint32 numWords,
        address indexed sender
    );

    event RandomWordsFulfilled(uint256 indexed requestId, uint256[] randomWords);

    function requestRandomWords(
        bytes32 keyHash,
        uint256 subId,
        uint16 minimumRequestConfirmations,
        uint32 callbackGasLimit,
        uint32 numWords
    ) external returns (uint256) {
        uint256 requestId = s_nextRequestId++;
        s_requests[requestId] = Request({consumer: msg.sender, numWords: numWords});

        emit RandomWordsRequested(
            keyHash,
            requestId,
            subId,
            minimumRequestConfirmations,
            callbackGasLimit,
            numWords,
            msg.sender
        );

        return requestId;
    }

    /**
     * @notice Simulates Chainlink VRF responding with verifiable random numbers.
     */
    function fulfillRandomWords(uint256 requestId, address consumer) external {
        Request memory req = s_requests[requestId];
        uint32 numWords = req.numWords > 0 ? req.numWords : 1;

        uint256[] memory randomWords = new uint256[](numWords);
        for (uint32 i = 0; i < numWords; i++) {
            // Generate deterministic pseudo-random words for mock fulfillment
            randomWords[i] = uint256(keccak256(abi.encodePacked(block.timestamp, requestId, i)));
        }

        emit RandomWordsFulfilled(requestId, randomWords);
        IVRFConsumer(consumer).rawFulfillRandomWords(requestId, randomWords);
    }
}

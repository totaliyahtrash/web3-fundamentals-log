// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {SimpleStorage} from "./SimpleStorage.sol";

/**
 * @title StorageFactory
 * @author totaliyahtrash
 * @notice Demonstrates contract composability & the Factory Pattern in Solidity.
 * @dev Deploys, tracks, and interacts with multiple SimpleStorage contract instances on-chain.
 */
contract StorageFactory {
    // Array storing instances of deployed SimpleStorage contracts
    SimpleStorage[] public listOfSimpleStorageContracts;

    event ContractDeployed(uint256 indexed contractIndex, address indexed contractAddress);
    event RemoteStoreExecuted(uint256 indexed contractIndex, uint256 newNumber);

    /**
     * @notice Deploys a new SimpleStorage contract using the `new` keyword.
     */
    function createSimpleStorageContract() public returns (address) {
        SimpleStorage newSimpleStorageContract = new SimpleStorage();
        listOfSimpleStorageContracts.push(newSimpleStorageContract);
        
        uint256 newIndex = listOfSimpleStorageContracts.length - 1;
        emit ContractDeployed(newIndex, address(newSimpleStorageContract));
        return address(newSimpleStorageContract);
    }

    /**
     * @notice Calls `store()` on a specific deployed SimpleStorage instance.
     * @param _simpleStorageIndex The index of the target contract in our array.
     * @param _newSimpleStorageNumber The new value to store.
     */
    function sfStore(uint256 _simpleStorageIndex, uint256 _newSimpleStorageNumber) public {
        // Address + ABI interface interaction
        SimpleStorage targetContract = listOfSimpleStorageContracts[_simpleStorageIndex];
        targetContract.store(_newSimpleStorageNumber);
        emit RemoteStoreExecuted(_simpleStorageIndex, _newSimpleStorageNumber);
    }

    /**
     * @notice Calls `retrieve()` on a specific deployed SimpleStorage instance.
     * @param _simpleStorageIndex The index of the target contract in our array.
     * @return The stored favorite number in that contract instance.
     */
    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        return listOfSimpleStorageContracts[_simpleStorageIndex].retrieve();
    }

    /**
     * @notice Returns the total count of SimpleStorage contracts created.
     */
    function getContractsCount() public view returns (uint256) {
        return listOfSimpleStorageContracts.length;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title SimpleStorage
 * @author totaliyahtrash
 * @notice My first smart contract written during the Cyfrin Updraft curriculum.
 * @dev Demonstrates basic EVM data types, state variable storage, functions (view/pure vs state-changing),
 * structs, dynamic arrays, and key-value mappings.
 */
contract SimpleStorage {
    // -----------------------------------------------------------------------
    // State Variables (stored permanently on-chain in contract storage slots)
    // -----------------------------------------------------------------------
    
    // Initialized to 0 by default
    uint256 private myFavoriteNumber;

    // Struct: custom user-defined type to group related data
    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    // Dynamic Array: ordered list of Person structs
    Person[] public listOfPeople;

    // Mapping: O(1) key-value hash table linking a person's name to their favorite number
    mapping(string => uint256) public nameToFavoriteNumber;

    // -----------------------------------------------------------------------
    // Events
    // -----------------------------------------------------------------------
    event NumberUpdated(uint256 indexed oldNumber, uint256 indexed newNumber, address indexed sender);
    event PersonAdded(string name, uint256 favoriteNumber);

    // -----------------------------------------------------------------------
    // State-Changing Functions (Cost Gas)
    // -----------------------------------------------------------------------

    /**
     * @notice Stores a new number in contract state storage.
     * @param _favoriteNumber The new number to store.
     */
    function store(uint256 _favoriteNumber) public virtual {
        emit NumberUpdated(myFavoriteNumber, _favoriteNumber, msg.sender);
        myFavoriteNumber = _favoriteNumber;
    }

    /**
     * @notice Adds a new person with their favorite number to both the array and mapping.
     * @param _name Name of the person (passed as `calldata` for gas optimization).
     * @param _favoriteNumber The person's favorite number.
     */
    function addPerson(string calldata _name, uint256 _favoriteNumber) public {
        listOfPeople.push(Person(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
        emit PersonAdded(_name, _favoriteNumber);
    }

    // -----------------------------------------------------------------------
    // Read-Only Functions (Free when called off-chain)
    // -----------------------------------------------------------------------

    /**
     * @notice Reads the stored favorite number from contract storage.
     * @dev Marked as `view` because it reads state but does not modify it.
     * @return The currently stored favorite number.
     */
    function retrieve() public view returns (uint256) {
        return myFavoriteNumber;
    }

    /**
     * @notice Returns the total count of registered people.
     */
    function getPeopleCount() public view returns (uint256) {
        return listOfPeople.length;
    }
}

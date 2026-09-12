// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {SimpleStorage} from "./SimpleStorage.sol";

/**
 * @title AddFiveStorage
 * @author totaliyahtrash
 * @notice Demonstrates inheritance and function polymorphism in Solidity.
 * @dev Inherits all state variables and logic from SimpleStorage and overrides `store()`.
 */
contract AddFiveStorage is SimpleStorage {
    /**
     * @notice Overrides the parent `store()` function to automatically add +5 before storing.
     * @dev Uses `override` keyword to safely modify base contract behavior.
     * @param _newNumber Base input number.
     */
    function store(uint256 _newNumber) public override {
        // Calls the internal logic adding 5
        super.store(_newNumber + 5);
    }
}

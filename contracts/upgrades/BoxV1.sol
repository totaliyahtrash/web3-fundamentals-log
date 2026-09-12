// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title BoxV1
 * @author totaliyahtrash
 * @notice Version 1 implementation contract to be deployed behind an ERC-1967 proxy.
 * @dev Demonstrates upgradeable contract architecture. Uses initializer pattern instead of constructor.
 */
contract BoxV1 {
    // -----------------------------------------------------------------------
    // Storage Layout (Must never reorder or remove variables in future versions)
    // -----------------------------------------------------------------------
    uint256 internal s_value;
    bool private s_initialized;

    event ValueChanged(uint256 newValue);

    function initialize(uint256 initialValue) external {
        require(!s_initialized, "Already initialized");
        s_initialized = true;
        s_value = initialValue;
        emit ValueChanged(initialValue);
    }

    function setValue(uint256 newValue) external {
        s_value = newValue;
        emit ValueChanged(newValue);
    }

    function getValue() external view returns (uint256) {
        return s_value;
    }

    function version() external pure virtual returns (string memory) {
        return "1.0.0";
    }
}

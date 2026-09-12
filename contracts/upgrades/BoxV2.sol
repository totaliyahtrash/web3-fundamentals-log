// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {BoxV1} from "./BoxV1.sol";

/**
 * @title BoxV2
 * @author totaliyahtrash
 * @notice Version 2 implementation contract demonstrating state-preserving upgradeability.
 * @dev Inherits BoxV1 storage layout and introduces new `increment()` functionality.
 */
contract BoxV2 is BoxV1 {
    /**
     * @notice New functionality introduced in Version 2.
     * @dev Modifies inherited `s_value` state without causing storage collisions.
     */
    function increment() external {
        s_value += 1;
        emit ValueChanged(s_value);
    }

    function version() external pure override returns (string memory) {
        return "2.0.0";
    }
}

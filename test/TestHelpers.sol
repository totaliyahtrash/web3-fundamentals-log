// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title Minimal Foundry Cheatcode Interface (`vm`)
 * @notice Exposes common Foundry / Forge VM cheatcodes for standalone compilation and testing.
 */
interface Vm {
    function warp(uint256 newTimestamp) external;
    function roll(uint256 newNumber) external;
    function fee(uint256 newFee) external;
    function deal(address who, uint256 newBalance) external;
    function prank(address msgSender) external;
    function startPrank(address msgSender) external;
    function stopPrank() external;
    function expectRevert(bytes calldata revertData) external;
    function startBroadcast() external;
    function stopBroadcast() external;
}

/**
 * @title Minimal Test Base
 * @notice Provides assertions without requiring external forge-std installation.
 */
abstract contract Test {
    Vm internal constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function assertEq(uint256 a, uint256 b, string memory err) internal pure {
        require(a == b, err);
    }

    function assertEq(address a, address b, string memory err) internal pure {
        require(a == b, err);
    }

    function assertTrue(bool condition, string memory err) internal pure {
        require(condition, err);
    }
}

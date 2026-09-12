// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title ERC1967Proxy
 * @author totaliyahtrash
 * @notice Minimal ERC-1967 compliant upgradeable proxy contract.
 * @dev Delegates all calls to an implementation address stored at a standardized, collision-resistant slot.
 */
contract ERC1967Proxy {
    // -----------------------------------------------------------------------
    // ERC-1967 Storage Slots: keccak256("eip1967.proxy.implementation") - 1
    // -----------------------------------------------------------------------
    bytes32 private constant IMPLEMENTATION_SLOT = 
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    // keccak256("eip1967.proxy.admin") - 1
    bytes32 private constant ADMIN_SLOT = 
        0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    event Upgraded(address indexed implementation);
    event AdminChanged(address previousAdmin, address newAdmin);

    modifier onlyAdmin() {
        if (msg.sender != _getAdmin()) {
            revert("Proxy: Only admin can call");
        }
        _;
    }

    constructor(address _implementation, address _admin) {
        _setAdmin(_admin);
        _setImplementation(_implementation);
    }

    /**
     * @notice Upgrades the implementation address.
     * @param _newImplementation Address of the newly deployed logic contract.
     */
    function upgradeTo(address _newImplementation) external onlyAdmin {
        require(_newImplementation.code.length > 0, "Proxy: Implementation must be contract");
        _setImplementation(_newImplementation);
        emit Upgraded(_newImplementation);
    }

    function changeAdmin(address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0), "Proxy: New admin cannot be zero address");
        emit AdminChanged(_getAdmin(), _newAdmin);
        _setAdmin(_newAdmin);
    }

    function getImplementation() external view returns (address) {
        return _getImplementation();
    }

    function getAdmin() external view returns (address) {
        return _getAdmin();
    }

    // -----------------------------------------------------------------------
    // Internal Slot Helpers
    // -----------------------------------------------------------------------
    function _setImplementation(address newImp) private {
        bytes32 slot = IMPLEMENTATION_SLOT;
        assembly {
            sstore(slot, newImp)
        }
    }

    function _getImplementation() private view returns (address impl) {
        bytes32 slot = IMPLEMENTATION_SLOT;
        assembly {
            impl := sload(slot)
        }
    }

    function _setAdmin(address newAdm) private {
        bytes32 slot = ADMIN_SLOT;
        assembly {
            sstore(slot, newAdm)
        }
    }

    function _getAdmin() private view returns (address adm) {
        bytes32 slot = ADMIN_SLOT;
        assembly {
            adm := sload(slot)
        }
    }

    // -----------------------------------------------------------------------
    // Fallback & Delegatecall Dispatcher
    // -----------------------------------------------------------------------
    fallback() external payable {
        _delegate(_getImplementation());
    }

    receive() external payable {
        _delegate(_getImplementation());
    }

    function _delegate(address implementation) internal {
        assembly {
            // Copy calldata to memory
            calldatacopy(0, 0, calldatasize())

            // Execute delegatecall in the context of this proxy contract
            let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)

            // Copy returned data
            returndatacopy(0, 0, returndatasize())

            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }
}

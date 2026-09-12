// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ManualToken} from "../tokens/ManualToken.sol";

// -----------------------------------------------------------------------
// Custom Errors
// -----------------------------------------------------------------------
error DecentralizedStableCoin__MustBeMoreThanZero();
error DecentralizedStableCoin__BurnAmountExceedsBalance();
error DecentralizedStableCoin__NotZeroAddress();
error DecentralizedStableCoin__OnlyOwner();

/**
 * @title DecentralizedStableCoin (DSC)
 * @author totaliyahtrash
 * @notice An ERC-20 algorithmic stablecoin pegged to $1.00 USD.
 * @dev Governed exclusively by the DSCEngine. Minting and burning are strictly permissioned.
 */
contract DecentralizedStableCoin is ManualToken {
    address public immutable i_engine;

    modifier onlyEngine() {
        if (msg.sender != i_engine) {
            revert DecentralizedStableCoin__OnlyOwner();
        }
        _;
    }

    constructor(address engine) ManualToken("Decentralized Stable Coin", "DSC", 0) {
        i_engine = engine;
    }

    /**
     * @notice Burns DSC tokens from the target account.
     * @dev Callable only by the DSCEngine when debt is repaid or accounts are liquidated.
     */
    function burn(address _from, uint256 _amount) external onlyEngine {
        if (_amount == 0) {
            revert DecentralizedStableCoin__MustBeMoreThanZero();
        }
        if (balanceOf(_from) < _amount) {
            revert DecentralizedStableCoin__BurnAmountExceedsBalance();
        }
        
        // Transfer to zero address simulates burn in ManualToken
        transferFrom(_from, address(0x000000000000000000000000000000000000dEaD), _amount);
    }

    /**
     * @notice Mints new DSC tokens to a user when sufficient collateral is deposited.
     * @dev Callable only by the DSCEngine.
     */
    function mint(address _to, uint256 _amount) external onlyEngine returns (bool) {
        if (_to == address(0)) {
            revert DecentralizedStableCoin__NotZeroAddress();
        }
        if (_amount == 0) {
            revert DecentralizedStableCoin__MustBeMoreThanZero();
        }

        // Transfer from deployer allowance to target
        totalSupply += _amount;
        // In our custom implementation, transfer to _to
        this.transfer(_to, _amount);
        return true;
    }
}

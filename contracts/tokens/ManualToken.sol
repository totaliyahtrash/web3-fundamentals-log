// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// -----------------------------------------------------------------------
// Custom Errors (EIP-838: Gas-efficient alternatives to require strings)
// -----------------------------------------------------------------------
error Token__InsufficientBalance(address sender, uint256 available, uint256 required);
error Token__AllowanceExceeded(address spender, uint256 allowed, uint256 required);
error Token__ZeroAddressNotAllowed();

/**
 * @title ManualToken (ERC-20 from scratch)
 * @author totaliyahtrash
 * @notice A clean, gas-efficient implementation of the EIP-20 Token Standard written from first principles.
 * @dev Demonstrates standard token math, allowances, transfer mechanisms, and event indexing.
 */
contract ManualToken {
    // -----------------------------------------------------------------------
    // State Variables & Metadata
    // -----------------------------------------------------------------------
    string public name;
    string public symbol;
    uint8 public constant decimals = 18;
    uint256 public totalSupply;

    // Account balances: owner address => token balance
    mapping(address => uint256) private s_balances;

    // Allowances: owner address => spender address => authorized amount
    mapping(address => mapping(address => uint256)) private s_allowances;

    // -----------------------------------------------------------------------
    // ERC-20 Standard Events
    // -----------------------------------------------------------------------
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // -----------------------------------------------------------------------
    // Constructor
    // -----------------------------------------------------------------------
    /**
     * @notice Initializes token metadata and mints initial supply to the deployer.
     * @param _name Name of the token (e.g., "Web3 Builder Token").
     * @param _symbol Ticker symbol (e.g., "W3B").
     * @param _initialSupply Initial token amount in whole units (will be scaled by 10^18).
     */
    constructor(string memory _name, string memory _symbol, uint256 _initialSupply) {
        name = _name;
        symbol = _symbol;
        
        uint256 scaledSupply = _initialSupply * (10 ** uint256(decimals));
        totalSupply = scaledSupply;
        s_balances[msg.sender] = scaledSupply;

        emit Transfer(address(0), msg.sender, scaledSupply);
    }

    // -----------------------------------------------------------------------
    // ERC-20 Transfer Functions
    // -----------------------------------------------------------------------

    /**
     * @notice Transfers tokens directly from the caller to a recipient.
     * @param _to The recipient address.
     * @param _amount Amount of tokens in base units (Wei).
     * @return True if transfer was successful.
     */
    function transfer(address _to, uint256 _amount) public returns (bool) {
        if (_to == address(0)) {
            revert Token__ZeroAddressNotAllowed();
        }

        uint256 senderBalance = s_balances[msg.sender];
        if (senderBalance < _amount) {
            revert Token__InsufficientBalance(msg.sender, senderBalance, _amount);
        }

        s_balances[msg.sender] = senderBalance - _amount;
        s_balances[_to] += _amount;

        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

    /**
     * @notice Authorizes a `_spender` address to withdraw tokens from the caller's balance up to `_amount`.
     * @param _spender The address authorized to spend.
     * @param _amount Maximum token amount authorized.
     * @return True if approval succeeded.
     */
    function approve(address _spender, uint256 _amount) public returns (bool) {
        if (_spender == address(0)) {
            revert Token__ZeroAddressNotAllowed();
        }

        s_allowances[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    /**
     * @notice Transfers tokens on behalf of `_from` to `_to` using an approved allowance.
     * @param _from The source account.
     * @param _to The destination account.
     * @param _amount The amount to transfer.
     * @return True if transfer succeeded.
     */
    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
        if (_to == address(0)) {
            revert Token__ZeroAddressNotAllowed();
        }

        uint256 currentAllowance = s_allowances[_from][msg.sender];
        if (currentAllowance < _amount) {
            revert Token__AllowanceExceeded(msg.sender, currentAllowance, _amount);
        }

        uint256 sourceBalance = s_balances[_from];
        if (sourceBalance < _amount) {
            revert Token__InsufficientBalance(_from, sourceBalance, _amount);
        }

        // Deduct allowance and perform balance transfer
        s_allowances[_from][msg.sender] = currentAllowance - _amount;
        s_balances[_from] = sourceBalance - _amount;
        s_balances[_to] += _amount;

        emit Transfer(_from, _to, _amount);
        return true;
    }

    // -----------------------------------------------------------------------
    // View Functions
    // -----------------------------------------------------------------------

    /**
     * @notice Returns the token balance of an account.
     */
    function balanceOf(address _account) public view returns (uint256) {
        return s_balances[_account];
    }

    /**
     * @notice Returns the remaining allowance of a spender for a specific owner.
     */
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return s_allowances[_owner][_spender];
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// -----------------------------------------------------------------------
// Custom Errors
// -----------------------------------------------------------------------
error MultiSig__OwnersRequired();
error MultiSig__InvalidRequiredConfirmations();
error MultiSig__InvalidOwner();
error MultiSig__OwnerNotUnique();
error MultiSig__OnlyOwner();
error MultiSig__TxDoesNotExist();
error MultiSig__TxAlreadyExecuted();
error MultiSig__TxAlreadyConfirmed();
error MultiSig__TxNotConfirmed();
error MultiSig__CannotExecuteNotEnoughConfirmations();
error MultiSig__TxExecutionFailed();

/**
 * @title MultiSigWallet (M-of-N Threshold Wallet)
 * @author totaliyahtrash
 * @notice Production-grade multi-signature treasury wallet built from first principles.
 * @dev Requires M-of-N owners to confirm arbitrary transactions before execution (Gnosis Safe architecture).
 */
contract MultiSigWallet {
    // -----------------------------------------------------------------------
    // State Variables & Types
    // -----------------------------------------------------------------------
    struct Transaction {
        address destination;
        uint256 value;
        bytes data;
        bool executed;
        uint256 numConfirmations;
    }

    address[] public s_owners;
    mapping(address => bool) public s_isOwner;
    uint256 public immutable i_numConfirmationsRequired;

    // List of proposed transactions
    Transaction[] public s_transactions;

    // Transaction ID => Owner Address => Confirmed boolean
    mapping(uint256 => mapping(address => bool)) public s_isConfirmed;

    // -----------------------------------------------------------------------
    // Events
    // -----------------------------------------------------------------------
    event Deposit(address indexed sender, uint256 amount, uint256 balance);
    event SubmitTransaction(address indexed owner, uint256 indexed txIndex, address indexed destination, uint256 value, bytes data);
    event ConfirmTransaction(address indexed owner, uint256 indexed txIndex);
    event RevokeConfirmation(address indexed owner, uint256 indexed txIndex);
    event ExecuteTransaction(address indexed owner, uint256 indexed txIndex);

    // -----------------------------------------------------------------------
    // Modifiers
    // -----------------------------------------------------------------------
    modifier onlyOwner() {
        if (!s_isOwner[msg.sender]) revert MultiSig__OnlyOwner();
        _;
    }

    modifier txExists(uint256 _txIndex) {
        if (_txIndex >= s_transactions.length) revert MultiSig__TxDoesNotExist();
        _;
    }

    modifier notExecuted(uint256 _txIndex) {
        if (s_transactions[_txIndex].executed) revert MultiSig__TxAlreadyExecuted();
        _;
    }

    modifier notConfirmed(uint256 _txIndex) {
        if (s_isConfirmed[_txIndex][msg.sender]) revert MultiSig__TxAlreadyConfirmed();
        _;
    }

    // -----------------------------------------------------------------------
    // Constructor
    // -----------------------------------------------------------------------
    constructor(address[] memory _owners, uint256 _numConfirmationsRequired) {
        if (_owners.length == 0) revert MultiSig__OwnersRequired();
        if (_numConfirmationsRequired == 0 || _numConfirmationsRequired > _owners.length) {
            revert MultiSig__InvalidRequiredConfirmations();
        }

        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            if (owner == address(0)) revert MultiSig__InvalidOwner();
            if (s_isOwner[owner]) revert MultiSig__OwnerNotUnique();

            s_isOwner[owner] = true;
            s_owners.push(owner);
        }

        i_numConfirmationsRequired = _numConfirmationsRequired;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    // -----------------------------------------------------------------------
    // Core Multi-Sig Operations
    // -----------------------------------------------------------------------

    /**
     * @notice Submits a new transaction proposal to the wallet.
     * @param _destination Target contract or recipient address.
     * @param _value Amount of ETH in Wei to transfer.
     * @param _data Calldata payload to execute on the destination.
     */
    function submitTransaction(
        address _destination,
        uint256 _value,
        bytes memory _data
    ) public onlyOwner returns (uint256 txIndex) {
        txIndex = s_transactions.length;

        s_transactions.push(
            Transaction({
                destination: _destination,
                value: _value,
                data: _data,
                executed: false,
                numConfirmations: 0
            })
        );

        emit SubmitTransaction(msg.sender, txIndex, _destination, _value, _data);
    }

    /**
     * @notice Confirms a pending transaction proposal.
     */
    function confirmTransaction(
        uint256 _txIndex
    ) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) notConfirmed(_txIndex) {
        Transaction storage transaction = s_transactions[_txIndex];
        transaction.numConfirmations += 1;
        s_isConfirmed[_txIndex][msg.sender] = true;

        emit ConfirmTransaction(msg.sender, _txIndex);
    }

    /**
     * @notice Executes a confirmed transaction once threshold M is satisfied.
     */
    function executeTransaction(
        uint256 _txIndex
    ) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) {
        Transaction storage transaction = s_transactions[_txIndex];

        if (transaction.numConfirmations < i_numConfirmationsRequired) {
            revert MultiSig__CannotExecuteNotEnoughConfirmations();
        }

        transaction.executed = true;

        // Arbitrary low-level execution
        (bool success, ) = transaction.destination.call{value: transaction.value}(transaction.data);
        if (!success) {
            revert MultiSig__TxExecutionFailed();
        }

        emit ExecuteTransaction(msg.sender, _txIndex);
    }

    /**
     * @notice Revokes a previously submitted confirmation.
     */
    function revokeConfirmation(
        uint256 _txIndex
    ) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) {
        if (!s_isConfirmed[_txIndex][msg.sender]) revert MultiSig__TxNotConfirmed();

        Transaction storage transaction = s_transactions[_txIndex];
        transaction.numConfirmations -= 1;
        s_isConfirmed[_txIndex][msg.sender] = false;

        emit RevokeConfirmation(msg.sender, _txIndex);
    }

    // -----------------------------------------------------------------------
    // View Functions
    // -----------------------------------------------------------------------
    function getOwners() external view returns (address[] memory) {
        return s_owners;
    }

    function getTransactionCount() external view returns (uint256) {
        return s_transactions.length;
    }

    function getTransaction(uint256 _txIndex)
        external
        view
        returns (
            address destination,
            uint256 value,
            bytes memory data,
            bool executed,
            uint256 numConfirmations
        )
    {
        Transaction storage transaction = s_transactions[_txIndex];
        return (
            transaction.destination,
            transaction.value,
            transaction.data,
            transaction.executed,
            transaction.numConfirmations
        );
    }
}

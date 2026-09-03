// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {PriceConverter, AggregatorV3Interface} from "./PriceConverter.sol";

// -----------------------------------------------------------------------
// Custom Errors (EIP-838: Gas-efficient alternatives to require strings)
// -----------------------------------------------------------------------
error FundMe__NotOwner();
error FundMe__DidNotSendEnoughETH(uint256 sentUsdValue, uint256 minimumUsdRequired);
error FundMe__WithdrawFailed();

/**
 * @title FundMe
 * @author totaliyahtrash
 * @notice A decentralized crowdfunding contract with Chainlink Price Feeds and gas optimizations.
 * @dev Implements custom errors, immutable/constant variables, library usage, and cheaper storage iteration.
 */
contract FundMe {
    // Attach the PriceConverter library to all uint256 types
    using PriceConverter for uint256;

    // -----------------------------------------------------------------------
    // State Variables (Constants & Immutables save EVM storage read gas)
    // -----------------------------------------------------------------------

    // Minimum funding threshold: $5 USD (in 18 decimals)
    // `constant`: Compiled directly into bytecode (0 storage read cost)
    uint256 public constant MINIMUM_USD = 5 * 1e18;

    // `immutable`: Assigned once in constructor, stored in contract bytecode
    address public immutable i_owner;

    // Chainlink Price Feed interface
    AggregatorV3Interface public immutable i_priceFeed;

    // List of addresses that have funded the contract
    address[] private s_funders;

    // Tracks total amount funded per contributor
    mapping(address => uint256) private s_addressToAmountFunded;

    // -----------------------------------------------------------------------
    // Events
    // -----------------------------------------------------------------------
    event Funded(address indexed funder, uint256 indexed ethAmount, uint256 usdValue);
    event Withdrawn(address indexed owner, uint256 totalAmount);

    // -----------------------------------------------------------------------
    // Modifiers
    // -----------------------------------------------------------------------
    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _;
    }

    // -----------------------------------------------------------------------
    // Constructor
    // -----------------------------------------------------------------------
    /**
     * @notice Initializes the contract owner and Chainlink Price Feed aggregator.
     * @param priceFeedAddress The address of the AggregatorV3Interface (e.g., Sepolia ETH/USD feed).
     */
    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        i_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    // -----------------------------------------------------------------------
    // Fallback & Receive (Handle direct ETH transfers to contract)
    // -----------------------------------------------------------------------
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    // -----------------------------------------------------------------------
    // Core Functions
    // -----------------------------------------------------------------------

    /**
     * @notice Allows users to fund the contract with native ETH.
     * @dev Enforces a minimum USD value using the Chainlink oracle.
     */
    function fund() public payable {
        uint256 usdValueOfContribution = msg.value.getConversionRate(i_priceFeed);
        
        if (usdValueOfContribution < MINIMUM_USD) {
            revert FundMe__DidNotSendEnoughETH(usdValueOfContribution, MINIMUM_USD);
        }

        // Record contributor data
        if (s_addressToAmountFunded[msg.sender] == 0) {
            s_funders.push(msg.sender);
        }
        s_addressToAmountFunded[msg.sender] += msg.value;

        emit Funded(msg.sender, msg.value, usdValueOfContribution);
    }

    /**
     * @notice Standard withdrawal function for the owner.
     * @dev Resets funder mappings and transfers all contract balance to owner.
     */
    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        // Reset the dynamic array
        s_funders = new address[](0);

        // Native transfer via `call` (recommended practice over `transfer` and `send`)
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        if (!callSuccess) {
            revert FundMe__WithdrawFailed();
        }

        emit Withdrawn(msg.sender, address(this).balance);
    }

    /**
     * @notice Gas-optimized withdrawal pattern.
     * @dev Caches `s_funders` storage array into EVM `memory` to avoid expensive SLOAD opcodes (2100 gas each).
     */
    function cheaperWithdraw() public onlyOwner {
        // Read storage array once into memory
        address[] memory funders = s_funders;

        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        s_funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        if (!callSuccess) {
            revert FundMe__WithdrawFailed();
        }

        emit Withdrawn(msg.sender, address(this).balance);
    }

    // -----------------------------------------------------------------------
    // Getter / View Functions
    // -----------------------------------------------------------------------

    function getAddressToAmountFunded(address fundingAddress) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getFundersCount() external view returns (uint256) {
        return s_funders.length;
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }

    function getPriceFeed() external view returns (AggregatorV3Interface) {
        return i_priceFeed;
    }
}

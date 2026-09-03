// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "./TestHelpers.sol";
import {FundMe, FundMe__NotOwner, FundMe__DidNotSendEnoughETH} from "../contracts/FundMe.sol";
import {MockV3Aggregator} from "../contracts/mocks/MockV3Aggregator.sol";

/**
 * @title FundMeTest
 * @author totaliyahtrash
 * @notice Automated Foundry unit test suite for FundMe.sol.
 * @dev Demonstrates cheatcodes (`prank`, `deal`), custom error assertions, and gas benchmarking.
 */
contract FundMeTest is Test {
    FundMe internal fundMe;
    MockV3Aggregator internal mockPriceFeed;

    address internal constant USER = address(0x1111);
    uint256 internal constant SEND_VALUE = 0.1 ether; // ~ $300 at $3k/ETH
    uint256 internal constant STARTING_USER_BALANCE = 10 ether;

    uint8 internal constant DECIMALS = 8;
    int256 internal constant INITIAL_PRICE = 3000e8; // $3,000 / ETH

    function setUp() external {
        // 1. Deploy local Mock Price Feed
        mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        
        // 2. Deploy FundMe with Mock Feed address
        fundMe = new FundMe(address(mockPriceFeed));
        
        // 3. Fund test user with 10 ETH
        vm.deal(USER, STARTING_USER_BALANCE);
    }

    /* -------------------------------------------------------------------------- */
    /*                              INITIAL STATE TESTS                           */
    /* -------------------------------------------------------------------------- */

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5 * 1e18, "Minimum USD should be 5 * 1e18");
    }

    function testOwnerIsDeployer() public view {
        assertEq(fundMe.getOwner(), address(this), "Owner should be test deployer");
    }

    /* -------------------------------------------------------------------------- */
    /*                                FUNDING TESTS                               */
    /* -------------------------------------------------------------------------- */

    function testFundFailsWithoutEnoughETH() public {
        // Expect revert due to zero value (less than $5 USD)
        vm.expectRevert(
            abi.encodeWithSelector(
                FundMe__DidNotSendEnoughETH.selector,
                0,
                5 * 1e18
            )
        );
        fundMe.fund{value: 0}();
    }

    function testFundUpdatesFundedDataStructure() public {
        // Simulate USER sending 0.1 ETH
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE, "Funded balance should match sent value");
        assertEq(fundMe.getFunder(0), USER, "First funder address should be USER");
    }

    /* -------------------------------------------------------------------------- */
    /*                              WITHDRAWAL TESTS                              */
    /* -------------------------------------------------------------------------- */

    function testOnlyOwnerCanWithdraw() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        // Non-owner (USER) attempts to call withdraw -> should revert
        vm.prank(USER);
        vm.expectRevert(abi.encodeWithSelector(FundMe__NotOwner.selector));
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public {
        // Arrange
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        uint256 startingOwnerBalance = address(this).balance;
        uint256 startingContractBalance = address(fundMe).balance;

        // Act
        fundMe.withdraw();

        // Assert
        uint256 endingOwnerBalance = address(this).balance;
        uint256 endingContractBalance = address(fundMe).balance;

        assertEq(endingContractBalance, 0, "Contract balance should be drained to 0");
        assertEq(
            startingOwnerBalance + startingContractBalance,
            endingOwnerBalance,
            "Owner balance should receive total contract funds"
        );
    }

    function testCheaperWithdrawGasOptimization() public {
        // Arrange: 5 separate funders
        for (uint160 i = 1; i <= 5; i++) {
            address funder = address(i + 100);
            vm.deal(funder, 1 ether);
            vm.prank(funder);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingContractBalance = address(fundMe).balance;

        // Act: Measure gas consumed by cheaperWithdraw()
        uint256 gasStart = gasleft();
        fundMe.cheaperWithdraw();
        uint256 gasUsed = gasStart - gasleft();

        // Assert
        assertEq(address(fundMe).balance, 0, "Contract balance should be 0");
        assertTrue(gasUsed > 0, "Gas should be tracked");
    }
}

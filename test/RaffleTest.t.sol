// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "./TestHelpers.sol";
import {
    Raffle,
    Raffle__SendMoreToEnterRaffle,
    Raffle__RaffleNotOpen,
    Raffle__UpkeepNotNeeded
} from "../contracts/raffle/Raffle.sol";
import {MockVRFCoordinator} from "../contracts/mocks/MockVRFCoordinator.sol";

/**
 * @title RaffleTest
 * @author totaliyahtrash
 * @notice Automated Foundry unit test suite for the Raffle smart contract.
 * @dev Tests state transitions, time-warping (`vm.warp`), automation upkeep triggers, and VRF fulfillment.
 */
contract RaffleTest is Test {
    Raffle internal raffle;
    MockVRFCoordinator internal vrfCoordinator;

    uint256 internal constant ENTRANCE_FEE = 0.01 ether;
    uint256 internal constant INTERVAL = 30 seconds;
    bytes32 internal constant GAS_LANE = bytes32(0);
    uint256 internal constant SUB_ID = 1;
    uint32 internal constant CALLBACK_GAS_LIMIT = 500_000;

    address internal constant PLAYER = address(0x1234);
    uint256 internal constant STARTING_PLAYER_BALANCE = 10 ether;

    function setUp() external {
        vrfCoordinator = new MockVRFCoordinator();
        raffle = new Raffle(
            ENTRANCE_FEE,
            INTERVAL,
            address(vrfCoordinator),
            GAS_LANE,
            SUB_ID,
            CALLBACK_GAS_LIMIT
        );
        vm.deal(PLAYER, STARTING_PLAYER_BALANCE);
    }

    /* -------------------------------------------------------------------------- */
    /*                              INITIAL STATE TESTS                           */
    /* -------------------------------------------------------------------------- */

    function testRaffleInitializesInOpenState() public view {
        assertTrue(
            raffle.getRaffleState() == Raffle.RaffleState.OPEN,
            "Raffle must initialize as OPEN"
        );
    }

    function testEntranceFeeIsAccurate() public view {
        assertEq(raffle.getEntranceFee(), ENTRANCE_FEE, "Entrance fee mismatch");
    }

    /* -------------------------------------------------------------------------- */
    /*                              ENTER RAFFLE TESTS                            */
    /* -------------------------------------------------------------------------- */

    function testRaffleRevertsWhenYouDontPayEnough() public {
        vm.prank(PLAYER);
        vm.expectRevert(abi.encodeWithSelector(Raffle__SendMoreToEnterRaffle.selector));
        raffle.enterRaffle{value: 0.001 ether}();
    }

    function testRaffleRecordsPlayerWhenTheyEnter() public {
        vm.prank(PLAYER);
        raffle.enterRaffle{value: ENTRANCE_FEE}();

        assertEq(raffle.getPlayer(0), PLAYER, "Player should be registered");
        assertEq(raffle.getNumberOfPlayers(), 1, "Player count should be 1");
    }

    function testCantEnterWhenRaffleIsCalculating() public {
        // 1. Enter raffle
        vm.prank(PLAYER);
        raffle.enterRaffle{value: ENTRANCE_FEE}();

        // 2. Advance time past interval
        vm.warp(block.timestamp + INTERVAL + 1);
        vm.roll(block.number + 1);

        // 3. Trigger performUpkeep -> state becomes CALCULATING
        raffle.performUpkeep("");

        // 4. Try entering while CALCULATING -> must revert
        vm.prank(PLAYER);
        vm.expectRevert(abi.encodeWithSelector(Raffle__RaffleNotOpen.selector));
        raffle.enterRaffle{value: ENTRANCE_FEE}();
    }

    /* -------------------------------------------------------------------------- */
    /*                             CHECK UPKEEP TESTS                             */
    /* -------------------------------------------------------------------------- */

    function testCheckUpkeepReturnsFalseIfItHasNoBalance() public {
        vm.warp(block.timestamp + INTERVAL + 1);
        vm.roll(block.number + 1);

        (bool upkeepNeeded, ) = raffle.checkUpkeep("");
        assertTrue(!upkeepNeeded, "Upkeep should be false when contract has no balance");
    }

    function testCheckUpkeepReturnsTrueWhenParametersAreGood() public {
        vm.prank(PLAYER);
        raffle.enterRaffle{value: ENTRANCE_FEE}();

        vm.warp(block.timestamp + INTERVAL + 1);
        vm.roll(block.number + 1);

        (bool upkeepNeeded, ) = raffle.checkUpkeep("");
        assertTrue(upkeepNeeded, "Upkeep should be true when time passed and has players");
    }

    /* -------------------------------------------------------------------------- */
    /*                           PERFORM UPKEEP & VRF TESTS                       */
    /* -------------------------------------------------------------------------- */

    function testPerformUpkeepRevertsIfCheckUpkeepIsFalse() public {
        // No players, no balance
        vm.expectRevert(
            abi.encodeWithSelector(
                Raffle__UpkeepNotNeeded.selector,
                0,
                0,
                uint256(Raffle.RaffleState.OPEN)
            )
        );
        raffle.performUpkeep("");
    }

    function testFullRaffleLifecycleAndWinnerPayout() public {
        // Arrange: 4 players enter
        address[4] memory players = [
            address(0x11),
            address(0x22),
            address(0x33),
            address(0x44)
        ];

        for (uint256 i = 0; i < players.length; i++) {
            vm.deal(players[i], 1 ether);
            vm.prank(players[i]);
            raffle.enterRaffle{value: ENTRANCE_FEE}();
        }

        uint256 totalPrize = ENTRANCE_FEE * players.length;

        // Act 1: Warp time and trigger performUpkeep
        vm.warp(block.timestamp + INTERVAL + 1);
        vm.roll(block.number + 1);

        raffle.performUpkeep("");

        // Assert: Raffle is locked in CALCULATING state
        assertTrue(
            raffle.getRaffleState() == Raffle.RaffleState.CALCULATING,
            "State must be CALCULATING"
        );

        // Act 2: Simulate VRF Coordinator responding with random number
        vrfCoordinator.fulfillRandomWords(1, address(raffle));

        // Assert: Winner selected, state reset to OPEN, players reset to 0, prize transferred
        address winner = raffle.getRecentWinner();
        assertTrue(winner != address(0), "Winner should be selected");
        assertEq(raffle.getNumberOfPlayers(), 0, "Players array should be reset");
        assertTrue(
            raffle.getRaffleState() == Raffle.RaffleState.OPEN,
            "State must be reset to OPEN"
        );
        assertEq(address(raffle).balance, 0, "Raffle contract balance must be 0");
        assertTrue(winner.balance >= totalPrize, "Winner should receive the total prize pool");
    }
}

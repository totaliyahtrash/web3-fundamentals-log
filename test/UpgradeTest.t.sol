// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "./TestHelpers.sol";
import {BoxV1} from "../contracts/upgrades/BoxV1.sol";
import {BoxV2} from "../contracts/upgrades/BoxV2.sol";
import {ERC1967Proxy} from "../contracts/upgrades/ERC1967Proxy.sol";

/**
 * @title UpgradeTest
 * @author totaliyahtrash
 * @notice Automated Foundry unit test suite verifying ERC-1967 proxy upgrades and state preservation.
 */
contract UpgradeTest is Test {
    BoxV1 internal boxV1;
    BoxV2 internal boxV2;
    ERC1967Proxy internal proxy;

    address internal constant ADMIN = address(0xAAAA);
    address internal constant USER = address(0xBBBB);

    function setUp() external {
        // 1. Deploy Implementation V1
        boxV1 = new BoxV1();

        // 2. Deploy Proxy pointing to V1 with ADMIN
        proxy = new ERC1967Proxy(address(boxV1), ADMIN);

        // 3. Initialize Proxy state via BoxV1 interface
        BoxV1(address(proxy)).initialize(42);
    }

    function testProxyInitializesWithCorrectValue() public view {
        uint256 val = BoxV1(address(proxy)).getValue();
        assertEq(val, 42, "Proxy initialized value must be 42");
        assertEq(BoxV1(address(proxy)).version(), "1.0.0", "Version must be 1.0.0");
    }

    function testUpgradeToV2PreservesStateAndAddsIncrement() public {
        // 1. User updates value on V1
        BoxV1(address(proxy)).setValue(100);
        assertEq(BoxV1(address(proxy)).getValue(), 100, "Value updated to 100 on V1");

        // 2. Deploy Implementation V2
        boxV2 = new BoxV2();

        // 3. Admin upgrades Proxy to point to V2
        vm.prank(ADMIN);
        proxy.upgradeTo(address(boxV2));

        // 4. Assert Implementation changed
        assertEq(proxy.getImplementation(), address(boxV2), "Implementation must point to V2");

        // 5. CRITICAL INVARIANT: State (100) must be preserved across the upgrade!
        assertEq(BoxV2(address(proxy)).getValue(), 100, "Historical state must persist across upgrade");
        assertEq(BoxV2(address(proxy)).version(), "2.0.0", "Version must report 2.0.0");

        // 6. Test new V2 functionality (increment)
        BoxV2(address(proxy)).increment();
        assertEq(BoxV2(address(proxy)).getValue(), 101, "Increment must yield 101");
    }

    function testNonAdminCannotUpgrade() public {
        boxV2 = new BoxV2();

        // Non-admin (USER) attempts to call upgradeTo -> should revert
        vm.prank(USER);
        vm.expectRevert();
        proxy.upgradeTo(address(boxV2));
    }
}

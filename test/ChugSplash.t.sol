// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/contracts/ChugSplash.sol";
import "../src/HelloChugSplash.sol";

contract ChugSplashTest is Test {
    HelloChugSplash helloChugSplash;
    uint256 localFork;

    function setUp() public {
        ChugSplash chugsplash = new ChugSplash();
        vm.makePersistent(address(chugsplash));

        string memory configPath = "./chugsplash/config.ts";

        chugsplash.deploy(configPath, true);
        helloChugSplash = HelloChugSplash(chugsplash.getAddress(configPath, "MyFirstContract"));
    }

    function testNumber() public {
        assertEq(helloChugSplash.number(), 1);
    }

    function testStored() public {
        assertEq(helloChugSplash.stored(), true);
    }

    function testOtherStorage() public {
        assertEq(helloChugSplash.otherStorage(), 0x1111111111111111111111111111111111111111);
    }

    function testStorageName() public {
        assertEq(helloChugSplash.storageName(), 'First');
    }
}
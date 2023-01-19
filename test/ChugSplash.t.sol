// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "../src/contracts/ChugSplash.sol";
import "../src/HelloChugSplash.sol";

contract ChugSplashTest is Test, Script {
    ChugSplash public chugsplash;    
    HelloChugSplash helloChugSplash;
    uint256 localFork;

    function setUp() public {
        chugsplash = new ChugSplash();
        vm.makePersistent(address(chugsplash));

        string memory configPath = "./chugsplash/config.ts";
        bool silent = false;
        string memory key = vm.envString("PRIVATE_KEY");
        string memory outPath = vm.envString("OUT_PATH");
        string memory buildInfoPath = vm.envString("BUILD_INFO_PATH");

        ChugSplash.ChugSplashContract[] memory deployedContracts = chugsplash.deploy(
            configPath,
            "localhost",
            key,
            silent,
            outPath,
            buildInfoPath,
            false,
            "self",
            "none",
            false
        );

        address helloChugSplashAddress = chugsplash.fetchContractAddress(deployedContracts, 'HelloChugSplash', 'MyFirstContract');
        helloChugSplash = HelloChugSplash(helloChugSplashAddress);
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
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "../src/contracts/Reforge.sol";
import "../src/HelloReforge.sol";

contract ContractTest is Test, Script {
    Reforge public reforge;    
    HelloReforge helloReforge;
    uint256 localFork;

    function setUp() public {
        reforge = new Reforge();
        vm.makePersistent(address(reforge));

        string memory configPath = "./reforge/config.ts";
        bool silent = false;
        string memory key = vm.envString("PRIVATE_KEY");
        string memory outPath = vm.envString("OUT_PATH");
        string memory buildInfoPath = vm.envString("BUILD_INFO_PATH");

        Reforge.ReforgeContract[] memory deployedContracts = reforge.deploy(
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

        address helloReforgeAddress = reforge.fetchContractAddress(deployedContracts, 'HelloReforge', 'MyFirstContract');
        helloReforge = HelloReforge(helloReforgeAddress);
    }

    function testNumber() public {
        assertEq(helloReforge.number(), 1);
    }

    function testStored() public {
        assertEq(helloReforge.stored(), true);
    }

    function testOtherStorage() public {
        assertEq(helloReforge.otherStorage(), 0x1111111111111111111111111111111111111111);
    }

    function testStorageName() public {
        assertEq(helloReforge.storageName(), 'First');
    }
}
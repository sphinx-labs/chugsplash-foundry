# Foundry Testing
ChugSplash can be integrated with Foundry test scripts to run unit tests against contracts which have been deployed using ChugSplash. You can also use Foundry to fork a live network, and test our your upgrade using ChugSplash. 

## Create your test script

Take a look at the following deployment test example. To create you testing script, you'll want copy it and adjust it to retrieve the correct contracts for your deployment and of course run your tests. 
```
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import { ChugSplash } from "chugsplash-foundry/contracts/ChugSplash.sol";
import "../src/HelloChugSplash.sol";

contract ContractTest is Test, Script {
    ChugSplash public chugsplash;    
    HelloChugSplash helloChugSplash;
    uint256 localFork;

    // Setup your tests
    function setUp() public {
        // Start by setting up ChugSplash and configuring it to be peristed across Forks
        chugsplash = new ChugSplash();
        vm.makePersistent(address(chugsplash));

        // Define the variables required to perform the deployment
        string memory configPath = "./chugsplash/config.ts";
        bool silent = false;
        string memory key = vm.envString("PRIVATE_KEY");
        string memory outPath = vm.envString("OUT_PATH");
        string memory buildInfoPath = vm.envString("BUILD_INFO_PATH");

        // Perform the deployment using ChugSplash
        ChugSplash.ChugSplashContract[] memory deployedContracts = chugsplash.deploy(
            configPath,
            "localhost",
            key,
            silent,
            outPath,
            buildInfoPath,
            false,
            "self",
            "none"
        );

        // Fetch the address of the deployed contract by passing
        // deployedContracts: Artifacts used to access the deployed contract.
        // HelloChugSplash: The name of the contract.
        // MyFirstContract: The reference name of the contract, this is the key for the contract in the deployment configuration file
        address helloChugSplashAddress = chugsplash.fetchContractAddress(deployedContracts, 'HelloChugSplash', 'MyFirstContract');

        // Define the contract using the retrieved address
        helloChugSplash = HelloChugSplash(helloChugSplashAddress);
    }

    // Run your deployment tests
    // Here we just confirm that the deployment was performed correctly, but you can implement whatever tests you like. 
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
```

## Running Tests
First start a standalone anvil process, this is required for performing ChugSplash deployments. 
```
anvil
```

If you would like to test against a forked network:
```
anvil --fork-url <rpc url>
```

Finally run your tests against that process:
```
forge test --rpc-url http://localhost:8545
```
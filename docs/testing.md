# Foundry Testing
Reforge can be integrated with Foundry test scripts to run unit tests against contracts which have been deployed using Reforge. You can also use Foundry to fork a live network, and test our your upgrade using Reforge. 

## Create your test script

Take a look at the following deployment test example. To create you testing script, you'll want copy it and adjust it to retrieve the correct contracts for your deployment and of course run your tests. 
```
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import { Reforge } from "Reforge/contracts/Reforge.sol";
import "../src/HelloReforge.sol";

contract ContractTest is Test, Script {
    Reforge public reforge;    
    HelloReforge helloReforge;
    uint256 localFork;

    // Setup your tests
    function setUp() public {
        // Start by setting up Reforge and configuring it to be peristed across Forks
        reforge = new Reforge();
        vm.makePersistent(address(reforge));

        // Define the variables required to perform the deployment
        string memory configPath = "./reforge/config.ts";
        bool silent = false;
        string memory key = vm.envString("PRIVATE_KEY");
        string memory outPath = vm.envString("OUT_PATH");
        string memory buildInfoPath = vm.envString("BUILD_INFO_PATH");

        // Perform the deployment using Reforge
        Reforge.ReforgeContract[] memory deployedContracts = reforge.deploy(
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
        // HelloReforge: The name of the contract.
        // MyFirstContract: The reference name of the contract, this is the key for the contract in the deployment configuration file
        address helloReforgeAddress = reforge.fetchContractAddress(deployedContracts, 'HelloReforge', 'MyFirstContract');

        // Define the contract using the retrieved address
        helloReforge = HelloReforge(helloReforgeAddress);
    }

    // Run your deployment tests
    // Here we just confirm that the deployment was performed correctly, but you can implement whatever tests you like. 
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
```

## Running Tests
First start a standalone anvil process, this is required for performing Reforge deployments. 
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
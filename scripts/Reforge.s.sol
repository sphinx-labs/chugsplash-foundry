// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/contracts/Reforge.sol";
import "../src/HelloReforge.sol";

contract ReforgeDeploy is Script {
    Reforge public reforge;    

    function setUp() public {
        reforge = new Reforge();
    }

    function run() public {
        string memory configPath = "./reforge/config.ts";
        bool silent = false;
        string memory key = vm.envString("PRIVATE_KEY");
        string memory outPath = vm.envString("OUT_PATH");
        string memory buildInfoPath = vm.envString("BUILD_INFO_PATH");

        reforge.register(
            configPath,
            "localhost",
            key, 
            silent,
            outPath,
            buildInfoPath,
            "self"
        );

        // reforge.deploy(
        //     configPath,
        //     rpcUrl,
        //     network,
        //     key,
        //     silent,
        //     false,
        //     outPath,
        //     "self",
        //     "none"
        // );
    }
}

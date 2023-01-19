// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/contracts/ChugSplash.sol";
import "../src/HelloChugSplash.sol";

contract ChugSplashDeploy is Script {
    ChugSplash public chugsplash;    

    function setUp() public {
        chugsplash = new ChugSplash();
    }

    function run() public {
        string memory configPath = "./chugsplash/config.ts";
        bool silent = false;
        string memory key = vm.envString("PRIVATE_KEY");
        
        chugsplash.register(
            configPath,
            "localhost",
            key, 
            silent,
            "self"
        );

        // chugsplash.deploy(
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

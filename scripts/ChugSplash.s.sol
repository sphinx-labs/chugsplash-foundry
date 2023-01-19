// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/contracts/ChugSplash.sol";
import "../src/HelloChugSplash.sol";

contract ChugSplashDeploy is Script {
    function run() public {
        string memory configPath = "./chugsplash/config.ts";
        ChugSplash chugsplash = new ChugSplash();
        // chugsplash.register(configPath);

        chugsplash.deploy(configPath);
    }
}

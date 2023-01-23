// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ChugSplash.sol";
import "../src/SimpleStorage.sol";
import "../src/Storage.sol";

contract ChugSplashDeploy is Script {
    function run() public {
        string memory configPath = "./chugsplash/deploy.t.ts";
        ChugSplash chugsplash = new ChugSplash();
        // chugsplash.register(configPath);

        chugsplash.deploy(configPath);
    }
}

pragma solidity ^0.8.17;

// SPDX-License-Identifier: MIT
import "forge-std/Script.sol"; 
import "forge-std/Test.sol"; 
import "github.com/Arachnid/solidity-stringutils/strings.sol";

contract ChugSplash is Script, Test {
    using strings for *;
    
    struct ChugSplashContract {
        string referenceName;
        string contractName;
        address contractAddress;
    }

    function fetchContractAddress(
        ChugSplashContract[] memory deployedContracts,
        bytes memory contractName,
        bytes memory referenceName
    ) external returns (address) {
        for (uint i = 0; i < deployedContracts.length; i++) {
            bytes32 encodedContractName = keccak256(abi.encodePacked(deployedContracts[i].contractName));
            bytes32 encodedReferenceName = keccak256(abi.encodePacked(deployedContracts[i].referenceName));
            if (encodedContractName == keccak256(contractName) && encodedReferenceName == keccak256(referenceName)) {
                emit log("found contract");
                return deployedContracts[i].contractAddress;
            }
        }

        revert("contract address not found, are you sure you specified the correct contract and reference name");
    }

    function register(
        string memory configPath, 
        string memory network, 
        string memory privateKey, 
        bool silent, 
        string memory newOwner
    ) external returns (bytes memory) {
        string memory rpcUrl = vm.rpcUrl(network);
        string memory filePath = vm.envOr("DEV_FILE_PATH", string('./lib/ChugSplash/src/index.ts'));

        string outFilePath = './out';
        string buildInfoOut = './out/build-info';
        string memory tomlPath = "foundry.toml";
        string memory line;
        while (line != "") {
            line = vm.readLine(tomlPath);
            if (line.starts("out")) {
                outFilePath = line.beyond("out");
            }
            if (buildInfoOut.starts("build_info_path")) {
                buildInfoOut = line.beyond("build_info_path");
            }
        }

        string[] memory cmds = new string[](12);
        cmds[0] = "npx";
        cmds[1] = "ts-node";
        cmds[2] = filePath;
        cmds[3] = "register";
        cmds[4] = configPath;
        cmds[5] = rpcUrl;
        cmds[6] = network;
        cmds[7] = privateKey;
        cmds[8] = silent == true ? "true" : "false";
        cmds[9] = outPath;
        cmds[10] = buildInfoPath;
        cmds[11] = newOwner;

        bytes memory result = vm.ffi(cmds);
        emit log(string(result));
        emit log(string("\n"));
        uint localFork = vm.createFork(rpcUrl);
        vm.selectFork(localFork);
        return result;
    }

    function propose(
        string memory configPath, 
        string memory network, 
        string memory privateKey, 
        bool silent, 
        string memory outPath,
        string memory buildInfoPath,
        string memory ipfsUrl,
        bool remoteExecution,
        bool skipStorageCheck
    ) external returns (bytes memory) {
        string memory rpcUrl = vm.rpcUrl(network);
        string memory filePath = vm.envOr("DEV_FILE_PATH", string('./lib/ChugSplash/src/index.ts'));

        string[] memory cmds = new string[](14);
        cmds[0] = "npx";
        cmds[1] = "ts-node";
        cmds[2] = filePath;
        cmds[3] = "propose";
        cmds[4] = configPath;
        cmds[5] = rpcUrl;
        cmds[6] = network;
        cmds[7] = privateKey;
        cmds[8] = silent == true ? "true" : "false";
        cmds[9] = outPath;
        cmds[10] = buildInfoPath;
        cmds[11] = ipfsUrl;
        cmds[12] = remoteExecution == true ? "true" : "false";
        cmds[13] = skipStorageCheck == true ? "true" : "false";

        bytes memory result = vm.ffi(cmds);
        emit log(string(result));
        emit log(string("\n"));

        uint localFork = vm.createFork(rpcUrl);
        vm.selectFork(localFork);
        return result;
    }

    function fund(
        string memory configPath, 
        string memory network, 
        string memory privateKey, 
        bool silent, 
        string memory outPath,
        string memory buildInfoPath,
        uint amount 
    ) external returns (bytes memory) {
        string memory rpcUrl = vm.rpcUrl(network);
        string memory filePath = vm.envOr("DEV_FILE_PATH", string('./lib/ChugSplash/src/index.ts'));

        string[] memory cmds = new string[](12);
        cmds[0] = "npx";
        cmds[1] = "ts-node";
        cmds[2] = filePath;
        cmds[3] = "fund";
        cmds[4] = configPath;
        cmds[5] = rpcUrl;
        cmds[6] = network;
        cmds[7] = privateKey;
        cmds[8] = silent == true ? "true" : "false";
        cmds[9] = outPath;
        cmds[10] = buildInfoPath;
        cmds[11] = vm.toString(amount);

        bytes memory result = vm.ffi(cmds);
        emit log(string(result));
        emit log(string("\n"));

        uint localFork = vm.createFork(rpcUrl);
        vm.selectFork(localFork);
        return result;
    }

    function approve(
        string memory configPath, 
        string memory network, 
        string memory privateKey, 
        bool silent, 
        string memory outPath,
        string memory buildInfoPath,
        bool withdrawFunds,
        bool skipMonitorStatus
    ) external returns (bytes memory) {
        string memory rpcUrl = vm.rpcUrl(network);
        string memory filePath = vm.envOr("DEV_FILE_PATH", string('./lib/ChugSplash/src/index.ts'));

        string[] memory cmds = new string[](13);
        cmds[0] = "npx";
        cmds[1] = "ts-node";
        cmds[2] = filePath;
        cmds[3] = "approve";
        cmds[4] = configPath;
        cmds[5] = rpcUrl;
        cmds[6] = network;
        cmds[7] = privateKey;
        cmds[8] = silent == true ? "true" : "false";
        cmds[9] = outPath;
        cmds[10] = buildInfoPath;
        cmds[11] = withdrawFunds == true ? "true" : "false";
        cmds[12] = skipMonitorStatus == true ? "true" : "false";

        bytes memory result = vm.ffi(cmds);
        emit log(string(result));
        emit log(string("\n"));

        uint localFork = vm.createFork(rpcUrl);
        vm.selectFork(localFork);
        return result;
    }

    function deploy(
        string memory configPath, 
        string memory network, 
        string memory privateKey, 
        bool silent, 
        string memory outPath,
        string memory buildInfoPath,
        bool withdrawFunds,
        string memory newOwner,
        string memory ipfsUrl,
        bool skipStorageCheck
    ) external returns (ChugSplashContract[] memory) {
        string memory rpcUrl = vm.rpcUrl(network);
        string memory filePath = vm.envOr("DEV_FILE_PATH", string('./lib/ChugSplash/src/index.ts'));

        string[] memory cmds = new string[](15);
        cmds[0] = "npx";
        cmds[1] = "ts-node";
        cmds[2] = filePath;
        cmds[3] = "deploy";
        cmds[4] = configPath;
        cmds[5] = rpcUrl;
        cmds[6] = network;
        cmds[7] = privateKey;
        cmds[8] = silent == true ? "true" : "false";
        cmds[9] = outPath;
        cmds[10] = buildInfoPath;
        cmds[11] = withdrawFunds == true ? "true" : "false";
        cmds[12] = newOwner;
        cmds[13] = ipfsUrl;
        cmds[14] = skipStorageCheck == true ? "true" : "false";

        bytes memory result = vm.ffi(cmds);
        ChugSplashContract[] memory deployedContracts = abi.decode(result, (ChugSplashContract[]));
        
        uint localFork = vm.createFork(rpcUrl);
        vm.selectFork(localFork);
        return deployedContracts;
    }

    function monitor(
        string memory configPath, 
        string memory network, 
        string memory privateKey, 
        bool silent, 
        string memory outPath,
        string memory buildInfoPath,
        string memory newOwner
    ) external returns (bytes memory) {
        string memory rpcUrl = vm.rpcUrl(network);
        string memory filePath = vm.envOr("DEV_FILE_PATH", string('./lib/ChugSplash/src/index.ts'));

        string[] memory cmds = new string[](12);
        cmds[0] = "npx";
        cmds[1] = "ts-node";
        cmds[2] = filePath;
        cmds[3] = "monitor";
        cmds[4] = configPath;
        cmds[5] = rpcUrl;
        cmds[6] = network;
        cmds[7] = privateKey;
        cmds[8] = silent == true ? "true" : "false";
        cmds[9] = outPath;
        cmds[10] = buildInfoPath;
        cmds[11] = newOwner;

        bytes memory result = vm.ffi(cmds);
        emit log(string(result));
        emit log(string("\n"));

        uint localFork = vm.createFork(rpcUrl);
        vm.selectFork(localFork);
        return result;
    }

    function cancel(
        string memory configPath, 
        string memory network, 
        string memory privateKey,
        string memory outPath,
        string memory buildInfoPath
    ) external returns (bytes memory) {
        string memory rpcUrl = vm.rpcUrl(network);
        string memory filePath = vm.envOr("DEV_FILE_PATH", string('./lib/ChugSplash/src/index.ts'));

        string[] memory cmds = new string[](10);
        cmds[0] = "npx";
        cmds[1] = "ts-node";
        cmds[2] = filePath;
        cmds[3] = "cancel";
        cmds[4] = configPath;
        cmds[5] = rpcUrl;
        cmds[6] = network;
        cmds[7] = privateKey;
        cmds[8] = outPath;
        cmds[9] = buildInfoPath;

        bytes memory result = vm.ffi(cmds);
        emit log(string(result));
        emit log(string("\n"));

        uint localFork = vm.createFork(rpcUrl);
        vm.selectFork(localFork);
        return result;
    }

    function withdraw(
        string memory configPath, 
        string memory network, 
        string memory privateKey, 
        bool silent, 
        string memory outPath,
        string memory buildInfoPath
    ) external returns (bytes memory) {
        string memory rpcUrl = vm.rpcUrl(network);
        string memory filePath = vm.envOr("DEV_FILE_PATH", string('./lib/ChugSplash/src/index.ts'));

        string[] memory cmds = new string[](11);
        cmds[0] = "npx";
        cmds[1] = "ts-node";
        cmds[2] = filePath;
        cmds[3] = "withdraw";
        cmds[4] = configPath;
        cmds[5] = rpcUrl;
        cmds[6] = network;
        cmds[7] = privateKey;
        cmds[8] = silent == true ? "true" : "false";
        cmds[9] = outPath;
        cmds[10] = buildInfoPath;

        bytes memory result = vm.ffi(cmds);
        emit log(string(result));
        emit log(string("\n"));

        uint localFork = vm.createFork(rpcUrl);
        vm.selectFork(localFork);
        return result;
    }

    function listProjects(
        string memory network, 
        string memory privateKey
    ) external returns (bytes memory) {
        string memory rpcUrl = vm.rpcUrl(network);
        string memory filePath = vm.envOr("DEV_FILE_PATH", string('./lib/ChugSplash/src/index.ts'));

        string[] memory cmds = new string[](7);
        cmds[0] = "npx";
        cmds[1] = "ts-node";
        cmds[2] = filePath;
        cmds[3] = "listProjects";
        cmds[4] = rpcUrl;
        cmds[5] = network;
        cmds[6] = privateKey;

        bytes memory result = vm.ffi(cmds);
        emit log(string(result));
        emit log(string("\n"));

        uint localFork = vm.createFork(rpcUrl);
        vm.selectFork(localFork);
        return result;
    }

    function listProposers(
        string memory configPath, 
        string memory network, 
        string memory privateKey,
        string memory outPath,
        string memory buildInfoPath
    ) external returns (bytes memory) {
        string memory rpcUrl = vm.rpcUrl(network);
        string memory filePath = vm.envOr("DEV_FILE_PATH", string('./lib/ChugSplash/src/index.ts'));

        string[] memory cmds = new string[](10);
        cmds[0] = "npx";
        cmds[1] = "ts-node";
        cmds[2] = filePath;
        cmds[3] = "listProposers";
        cmds[4] = configPath;
        cmds[5] = rpcUrl;
        cmds[6] = network;
        cmds[7] = privateKey;
        cmds[8] = outPath;
        cmds[9] = buildInfoPath;

        bytes memory result = vm.ffi(cmds);
        emit log(string(result));
        emit log(string("\n"));

        uint localFork = vm.createFork(rpcUrl);
        vm.selectFork(localFork);
        return result;
    }

    function addProposer(
        string memory configPath, 
        string memory network, 
        string memory privateKey, 
        address newProposer,
        string memory outPath,
        string memory buildInfoPath
    ) external returns (bytes memory) {
        string memory rpcUrl = vm.rpcUrl(network);
        string memory filePath = vm.envOr("DEV_FILE_PATH", string('./lib/ChugSplash/src/index.ts'));

        string[] memory cmds = new string[](11);
        cmds[0] = "npx";
        cmds[1] = "ts-node";
        cmds[2] = filePath;
        cmds[3] = "addProposer";
        cmds[4] = configPath;
        cmds[5] = rpcUrl;
        cmds[6] = network;
        cmds[7] = privateKey;
        cmds[8] = outPath;
        cmds[9] = buildInfoPath;
        cmds[10] = vm.toString(newProposer);

        bytes memory result = vm.ffi(cmds);
        emit log(string(result));
        emit log(string("\n"));

        uint localFork = vm.createFork(rpcUrl);
        vm.selectFork(localFork);
        return result;
    }

    function claimProxy(
        string memory configPath, 
        string memory network, 
        string memory privateKey, 
        bool silent, 
        string memory outPath,
        string memory buildInfoPath,
        string memory referenceName
    ) external returns (bytes memory) {
        string memory rpcUrl = vm.rpcUrl(network);
        string memory filePath = vm.envOr("DEV_FILE_PATH", string('./lib/ChugSplash/src/index.ts'));

        string[] memory cmds = new string[](12);
        cmds[0] = "npx";
        cmds[1] = "ts-node";
        cmds[2] = filePath;
        cmds[3] = "claimProxy";
        cmds[4] = configPath;
        cmds[5] = rpcUrl;
        cmds[6] = network;
        cmds[7] = privateKey;
        cmds[8] = silent == true ? "true" : "false";
        cmds[9] = outPath;
        cmds[10] = buildInfoPath;
        cmds[11] = referenceName;

        bytes memory result = vm.ffi(cmds);
        emit log(string(result));
        emit log(string("\n"));

        uint localFork = vm.createFork(rpcUrl);
        vm.selectFork(localFork);
        return result;
    }

    function transferProxy(
        string memory configPath, 
        string memory network, 
        string memory privateKey, 
        bool silent, 
        string memory outPath,
        string memory buildInfoPath,
        address proxyAddress
    ) external returns (bytes memory) {
        string memory rpcUrl = vm.rpcUrl(network);
        string memory filePath = vm.envOr("DEV_FILE_PATH", string('./lib/ChugSplash/src/index.ts'));

        string[] memory cmds = new string[](12);
        cmds[0] = "npx";
        cmds[1] = "ts-node";
        cmds[2] = filePath;
        cmds[3] = "transferProxy";
        cmds[4] = configPath;
        cmds[5] = rpcUrl;
        cmds[6] = network;
        cmds[7] = privateKey;
        cmds[8] = silent == true ? "true" : "false";
        cmds[9] = outPath;
        cmds[10] = buildInfoPath;
        cmds[11] = vm.toString(proxyAddress);

        bytes memory result = vm.ffi(cmds);
        emit log(string(result));
        emit log(string("\n"));

        uint localFork = vm.createFork(rpcUrl);
        vm.selectFork(localFork);
        return result;
    }
}
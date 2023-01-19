pragma solidity ^0.8.17;

// SPDX-License-Identifier: MIT
import "forge-std/Script.sol"; 
import "forge-std/Test.sol"; 
import "lib/solidity-stringutils/strings.sol";

contract ChugSplash is Script, Test {
    using strings for *;

    string constant NONE = "none";

    // Required env vars
    string privateKey = vm.envString("PRIVATE_KEY");
    string network = vm.envString("NETWORK");

    // Optional env vars
    address newOwnerAddress = vm.envOr("NEW_OWNER", vm.addr(vm.envUint("PRIVATE_KEY")));
    string newOwner = vm.toString(newOwnerAddress);
    bool withdrawFunds = vm.envOr("WITHDRAW_FUNDS", true);
    string ipfsUrl = vm.envOr("IPFS_URL", NONE);
    bool skipStorageCheck = vm.envOr("SKIP_STORAGE_CHECK", false);

    string rpcUrl = vm.rpcUrl(network);
    string filePath = vm.envOr("DEV_FILE_PATH", string('./lib/ChugSplash/src/index.ts'));
    
    struct ChugSplashContract {
        string referenceName;
        string contractName;
        address contractAddress;
    }

    function fetchPaths() private view returns (string memory outPath, string memory buildInfoPath) {
        outPath = './out';
        buildInfoPath = './out/build-info';
        string memory tomlPath = "foundry.toml";
        strings.slice memory line;
        while (!line.equals("".toSlice())) {
            line = vm.readLine(tomlPath).toSlice();
            if (line.startsWith("out".toSlice())) {
                outPath = line.beyond("out".toSlice()).toString();
            }
            if (line.startsWith("build_info_path".toSlice())) {
                buildInfoPath = line.beyond("build_info_path".toSlice()).toString();
            }
        }
    }

    function register(
        string memory configPath,
        bool silent
    ) external returns (bytes memory) {
        (string memory outPath, string memory buildInfoPath) = fetchPaths();

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
        bool remoteExecution,
        bool silent
    ) external returns (bytes memory) {
        (string memory outPath, string memory buildInfoPath) = fetchPaths();

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
        uint amount,
        bool silent
    ) external returns (bytes memory) {
        (string memory outPath, string memory buildInfoPath) = fetchPaths();

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
        bool skipMonitorStatus,
        bool silent
    ) external returns (bytes memory) {
        (string memory outPath, string memory buildInfoPath) = fetchPaths();

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
        string memory configPath
    ) external {
        deploy(configPath, false);
    }

    function deploy(
        string memory configPath,
        bool silent
    ) public {
        (string memory outPath, string memory buildInfoPath) = fetchPaths();

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

        if (silent == false) {
            emit log("Success!");
            for (uint i = 0; i < deployedContracts.length; i++) {
                ChugSplashContract memory deployed = deployedContracts[i];
                emit log(string.concat(deployed.referenceName, ': ', vm.toString(deployed.contractAddress)));
            }
        }

        uint localFork = vm.createFork(rpcUrl);
        vm.selectFork(localFork);
    }

    function monitor(
        string memory configPath,
        bool silent
    ) external returns (bytes memory) {
        (string memory outPath, string memory buildInfoPath) = fetchPaths();

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
        string memory configPath
    ) external returns (bytes memory) {
        (string memory outPath, string memory buildInfoPath) = fetchPaths();

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
        bool silent
    ) external returns (bytes memory) {
        (string memory outPath, string memory buildInfoPath) = fetchPaths();

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

    function listProjects() external returns (bytes memory) {
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
        string memory configPath
    ) external returns (bytes memory) {
        (string memory outPath, string memory buildInfoPath) = fetchPaths();

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
        address newProposer
    ) external returns (bytes memory) {
        (string memory outPath, string memory buildInfoPath) = fetchPaths();

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
        string memory referenceName,
        bool silent
    ) external returns (bytes memory) {
        (string memory outPath, string memory buildInfoPath) = fetchPaths();

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
        address proxyAddress,
        bool silent
    ) external returns (bytes memory) {
        (string memory outPath, string memory buildInfoPath) = fetchPaths();

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

    function getAddress(string memory _configPath, string memory _referenceName) public returns (address) {
        (string memory outPath, string memory buildInfoPath) = fetchPaths();

        string[] memory cmds = new string[](11);
        cmds[0] = "npx";
        cmds[1] = "ts-node";
        cmds[2] = filePath;
        cmds[3] = "getAddress";
        cmds[4] = rpcUrl;
        cmds[5] = _configPath;
        cmds[6] = _referenceName;
        cmds[7] = outPath;
        cmds[8] = buildInfoPath;

        bytes memory addrBytes = vm.ffi(cmds);
        address addr;
        assembly {
            addr := mload(add(addrBytes, 20))
        } 

        string memory errorMsg = string.concat(
            "Could not find contract: ",
            _referenceName,
            ". ",
            "Did you misspell the contract's reference name or forget to call `chugsplash.deploy`?"
        );
        require(addr.code.length > 0, errorMsg);

        return addr;
    }
}
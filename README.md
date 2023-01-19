# ChugSplash
A Foundry library for performing deterministic deployments and upgrades using [ChugSplash](https://github.com/chugsplash/chugsplash). If you're using hardhat, we recommend checking out the main [ChugSplash](https://github.com/chugsplash/chugsplash) repository. 

## Key Features
- Easy contract deployments and upgrades using declarative syntax
- Generates contract deployment artifacts for easy front end integration
- Automatically verifies contracts on Etherscan

## Performing upgrades
To perform an upgrade, you can simply rerun your deployment. Under the hood, ChugSplash will automatically detect which of your contracts have changed and perform only the necessary upgrades.

## Deployment Artifacts
Artifacts are generated for each network you deploy against in the /deployments directory. The artifacts are generated in the same format as hardhat-deploy.

## Getting Started
### 1. Install the ChugSplash library in your project.
```
forge install chugsplash/chugsplash-foundry
```

### 2. Setup ChugSplash Dependencies. 
Note that ChugSplash depends on Node and NPM, so you'll need them installed on your machine if you do not have them already. 
```
(cd lib/chugsplash-foundry && npm install)
```

### 3. Add the following configurations to your `foundry.toml` file. 
All of these options must be configured exactly like they are listed here or ChugSplash will not function properly. 
```
ffi = true
build_info = true
extra_output = ['storageLayout']
force = true

[rpc_endpoints]
localhost = "http://127.0.0.1:8545"
homestead = "${RPC_MAINNET}"
goerli = "${RPC_GOERLI}"
optimism = "${RPC_OPTIMISM}"
optimism-goerli = "${RPC_OPTIMISM_GOERLI}"
arbitrum = "${RPC_ARBITRUM}"
arbitrum-goerli = "${RPC_ARBITRUM_GOERLI}"
matic = "${RPC_MATIC}"
maticmum = "${RPC_MATIC_MUMBAI}"
```

### 4. Ensure you've configured the following options in your `foundry.toml`. 
These options may be configured as you see fit, but we recommend the following:
```
libs = ['lib']
out = 'out'
build_info_path = 'out/build-info'
```

### 5. Create a .env file and configure the following variables:
```
PRIVATE_KEY=<your private key>
OUT_PATH=<foundry output path>
BUILD_INFO_PATH=<foundry build info output path>
IPFS_PROJECT_ID=<IPFS Project ID>
IPFS_API_KEY_SECRET=<IPFS API Key Secret>
```

### 6. Add your deployment configuration
Create a `/chugsplash` directory in your project. Add a file `config.js` in that directory and paste in the following configuration template:
```js
require('@chugsplash/core')

module.exports = {
  options: {
    projectName: 'Hello ChugSplash',
  },
  contracts: {
    MyToken: {
      contract: 'ERC20',
      variables: {
        name: 'My Token',
        symbol: 'MYT',
        decimals: 18,
        totalSupply: 1000,
        balanceOf: {
          '0x0000000000000000000000000000000000000000': 1000,
        },
      },
    },
    MyMerkleDistributor: {
      contract: 'MerkleDistributor',
      variables: {
        token: '{{ MyToken }}', // MyToken's address. No keeping track of dependencies!
        merkleRoot: "0xc24c743268ce26f68cb820c7b58ec4841de32da07de505049b09405e0372cc41"
      }
    }
  },
}
```

If you prefer to use typescript, you may define your config file like this instead: 
```ts
import { UserChugSplashConfig } from '@chugsplash/core'

const config: UserChugSplashConfig = {
  options: {
    projectName: 'Hello ChugSplash',
  },
  contracts: {
    MyToken: {
      contract: 'ERC20',
      variables: {
        name: 'My Token',
        symbol: 'MYT',
        decimals: 18,
        totalSupply: 1000,
        balanceOf: {
          '0x0000000000000000000000000000000000000000': 1000,
        },
      },
    },
    MyMerkleDistributor: {
      contract: 'MerkleDistributor',
      variables: {
        token: '{{ MyToken }}', // MyToken's address. No keeping track of dependencies!
        merkleRoot: "0xc24c743268ce26f68cb820c7b58ec4841de32da07de505049b09405e0372cc41"
      }
    }
  },
}

export default config
```

The template above is a basic outline of a ChugSplash deployment configuration, but you'll need to adjust it to fit your specific deployment. This involves defining each of the contracts you would like to deploy, and the variables you'd like to set in them.

Please refer to the following documentation for more information on configuring deployments: 
- [ChugSplash File](https://github.com/chugsplash/chugsplash/blob/develop/docs/chugsplash-file.md): Detailed explanation of the file where you define a deployment or upgrade.
- [Defining Variables in a ChugSplash File](https://github.com/chugsplash/chugsplash/blob/develop/docs/variables.md): Comprehensive reference that explains how to assign values to every variable type in a ChugSplash file.

### 7. Create a forge deployment script file `deploy.s.sol` and paste in the following. 
This is a simple deployment script using ChugSplash that will deploy your project against a local node. To perform a deployment against a live network simply replace the network name `localhost` with the target network, ensure you've configured the required RPC url environment variable for that network, and configure a private key for a funded wallet on that network. 
```
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import { ChugSplash } from "chugsplash-foundry/contracts/ChugSplash.sol";


contract DeployTest is Script {
    ChugSplash chugsplash;

    function run() public {
        // Create the ChugSplash contract and ensure it is persisted across forks
        chugsplash = new ChugSplash();
        vm.makePersistent(address(chugsplash));

        string memory configPath = "./chugsplash/config.js";
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
            "none"
        );
    }
}

```

### 8. Run your deployment. 
Note that ChugSplash requires that you test your deployments against a local node running as a seperate process. You cannot use forge scripts internal node. 

Start an anvil node:
```
anvil
```

Run your deployment against it:
```
forge script scripts/Optimism.s.sol
```

Note: Some complex deployments can take quite a while to execute. You can find logs for all of your deployments including those still in progress in the `chugsplash/logs` directory. 

## Next Steps
- [API Documentation](https://github.com/chugsplash/chugsplash-foundry/blob/main/docs/api-docs.md): Learn about the ChugSplash API and more complex use cases.
- [Testing](https://github.com/chugsplash/chugsplash-foundry/blob/main/docs/testing.md): Learn how to use Foundry tests with ChugSplash.
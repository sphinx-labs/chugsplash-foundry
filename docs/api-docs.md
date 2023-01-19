# Reforge API Documentation

## Table of Contents

- [Deploy](#Deploy)
- [Register](#Register)
- [Propose](#Propose)
- [Approve](#Approve)
- [Fund](#Fund)
- [Monitor](#Monitor)
- [Withdraw](#Withdraw)
- [List Projects](#List-Projects)
- [List Proposers](#List-Proposers)
- [Add Proposer](#Add-Proposer)
- [Transfer Proxy](#Transfer-Proxy)


## Deploy
Performs a complete deployment from your local machine. 

### Example
```
string memory configPath = "./reforge/config.js";
string memory network = "localhost";
bool silent = false;
string memory key = vm.envString("PRIVATE_KEY");
string memory outPath = vm.envString("OUT_PATH");
string memory buildInfoPath = vm.envString("BUILD_INFO_PATH");
bool withdraw = false;
string memory newOwner = "self";
string memory ipfsUrl = "none";

Reforge.ReforgeContract[] memory deployedContracts = reforge.deploy(
    configPath,
    network,
    key,
    silent,
    outPath,
    buildInfoPath,
    withdraw,
    newOwner,
    ipfsUrl
);
```

### Parameters

#### configPath
- Type: string
- Description: Path to the configuration file for your deployment 

#### network
- Type: string
- Description: Name of the network you would like to deploy against, this must be defined in your foundry.toml file.

#### privateKey
- Type: string
- Description: A private key used to sign deployment transactions. 

#### Silent
- Type: bool
- Description: Whether to emit logs or not.

#### outPath
- Type: string 
- Description: Artifact output path defined in your foundry.toml file.

#### buildInfoPath
- Type: string
- Description: Build Info output path defined in your foundry.toml file. 

#### withdrawFunds
- Type: bool 
- Description: Whether to withdraw leftover funds from the Registry contract after the deployment is completed.

#### newOwner
- Type: string (address or "self")
- Description: A new owner address to transfer the project to after the deployment is complete. You may pass in "self" if you would like to retain ownership of the project after it is deployed.

#### ipfsUrl
- Type: string (ipfs url or "none")
- Description: Optional IPFS gateway URL for publishing ChugSplash projects to IPFS. You may pass in "none" if you do not want to use this feature. 

## Register
Registers a new project with the ChugSplash contracts and transfers it to the specified owner.

### Example 
```
string memory configPath = "./reforge/config.js";
string memory network = "localhost";
string memory privateKey = vm.envString("PRIVATE_KEY");
bool silent = false;
string memory newOwner = "self";
string memory outPath = vm.envString("OUT_PATH");
string memory buildInfoPath = vm.envString("BUILD_INFO_PATH");
string memory newOwner = "0x..."

reforge.register(
    configPath,
    network,
    privateKey, 
    silent,
    outPath,
    buildInfoPath,
    newOwner
);
```

### Parameters

#### Common Parameters
See the deploy function documentation for an explaination of the following common parameters.
- configPath
- network
- privateKey
- silent
- outPath
- buildInfo

#### newOwner
- Type: string (address or "self")
- Description: A new owner address to transfer the project to after it is registered. You may pass in "self" if you would like to retain ownership of the project.

## Propose
Todo 

## Approve
Todo

## Fund
Todo

## Monitor
Todo

## Cancel
Todo

## Withdraw
Todo

## List Projects
Todo

## List Proposers
Todo

## Add Proposer
Todo

## Transfer Proxy
Todo
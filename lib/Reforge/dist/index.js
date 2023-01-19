"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const fs = __importStar(require("fs"));
const core_1 = require("@chugsplash/core");
const ethers_1 = require("ethers");
const ora_1 = __importDefault(require("ora"));
const utils_1 = require("./utils");
const args = process.argv.slice(2);
const command = args[0];
(async () => {
    switch (command) {
        case 'register': {
            const configPath = args[1];
            const rpcUrl = args[2];
            const network = args[3] !== "localhost" ? args[3] : undefined;
            const privateKey = args[4];
            const silent = args[5] === 'true';
            const outPath = args[6];
            const buildInfoPath = args[6];
            let owner = args[7];
            const provider = new ethers_1.ethers.providers.JsonRpcProvider(rpcUrl, network);
            const wallet = new ethers_1.ethers.Wallet(privateKey, provider);
            const { artifactFolder, buildInfoFolder } = (0, utils_1.fetchPaths)(outPath, buildInfoPath);
            const userConfig = (0, core_1.readUserChugSplashConfig)(configPath);
            const artifactPaths = await (0, utils_1.getArtifactPaths)(userConfig.contracts, artifactFolder, buildInfoFolder);
            const config = (0, core_1.readParsedChugSplashConfig)(configPath, artifactPaths, "foundry");
            await provider.getNetwork();
            const address = await wallet.getAddress();
            owner = owner !== "self" ? owner : address;
            console.log("-- Reforge Register --");
            console.log(network);
            console.log(rpcUrl);
            await (0, core_1.chugsplashRegisterAbstractTask)(provider, wallet, [config], owner, silent, 'foundry', process.stdout);
            break;
        }
        case 'propose': {
            const configPath = args[1];
            const rpcUrl = args[2];
            const network = args[3] !== "localhost" ? args[3] : undefined;
            const privateKey = args[4];
            const silent = args[5] === 'true';
            const outPath = args[6];
            const buildInfoPath = args[7];
            const ipfsUrl = args[8] !== "none" ? args[6] : undefined;
            const remoteExecution = args[9] === 'true';
            const { artifactFolder, buildInfoFolder, canonicalConfigPath } = (0, utils_1.fetchPaths)(outPath, buildInfoPath);
            const userConfig = (0, core_1.readUserChugSplashConfig)(configPath);
            const artifactPaths = await (0, utils_1.getArtifactPaths)(userConfig.contracts, artifactFolder, buildInfoFolder);
            const provider = new ethers_1.ethers.providers.JsonRpcProvider(rpcUrl, network);
            const wallet = new ethers_1.ethers.Wallet(privateKey, provider);
            const config = (0, core_1.readParsedChugSplashConfig)(configPath, artifactPaths, "foundry");
            await provider.getNetwork();
            await wallet.getAddress();
            console.log("-- Reforge Propose --");
            await (0, core_1.chugsplashProposeAbstractTask)(provider, wallet, config, configPath, ipfsUrl, silent, remoteExecution, false, 'foundry', artifactPaths, buildInfoFolder, artifactFolder, canonicalConfigPath, process.stdout);
            break;
        }
        case 'fund': {
            const configPath = args[1];
            const rpcUrl = args[2];
            const network = args[3] !== "localhost" ? args[3] : undefined;
            const privateKey = args[4];
            const silent = args[5] === 'true';
            const outPath = args[6];
            const buildInfoPath = args[7];
            const amount = ethers_1.BigNumber.from(args[8]);
            const { artifactFolder, buildInfoFolder } = (0, utils_1.fetchPaths)(outPath, buildInfoPath);
            const userConfig = (0, core_1.readUserChugSplashConfig)(configPath);
            const artifactPaths = await (0, utils_1.getArtifactPaths)(userConfig.contracts, artifactFolder, buildInfoFolder);
            const provider = new ethers_1.ethers.providers.JsonRpcProvider(rpcUrl, network);
            const wallet = new ethers_1.ethers.Wallet(privateKey, provider);
            await provider.getNetwork();
            console.log("-- Reforge Fund --");
            await (0, core_1.chugsplashFundAbstractTask)(provider, wallet, configPath, amount, silent, artifactPaths, "foundry", process.stdout);
            break;
        }
        case 'approve': {
            const configPath = args[1];
            const rpcUrl = args[2];
            const network = args[3] !== "localhost" ? args[3] : undefined;
            const privateKey = args[4];
            const silent = args[5] === 'true';
            const outPath = args[6];
            const buildInfoPath = args[7];
            const withdrawFunds = args[8] === 'true';
            const skipMonitorStatus = args[9] === 'true';
            const { artifactFolder, buildInfoFolder, deploymentFolder, canonicalConfigPath } = (0, utils_1.fetchPaths)(outPath, buildInfoPath);
            const userConfig = (0, core_1.readUserChugSplashConfig)(configPath);
            const artifactPaths = await (0, utils_1.getArtifactPaths)(userConfig.contracts, artifactFolder, buildInfoFolder);
            const provider = new ethers_1.ethers.providers.JsonRpcProvider(rpcUrl, network);
            const wallet = new ethers_1.ethers.Wallet(privateKey, provider);
            await provider.getNetwork();
            await wallet.getAddress();
            const remoteExecution = args[3] !== 'localhost';
            console.log("-- Reforge Approve --");
            await (0, core_1.chugsplashApproveAbstractTask)(provider, wallet, configPath, !withdrawFunds, silent, skipMonitorStatus, artifactPaths, "foundry", buildInfoFolder, artifactFolder, canonicalConfigPath, deploymentFolder, remoteExecution, process.stdout);
            break;
        }
        case 'deploy': {
            const configPath = args[1];
            const rpcUrl = args[2];
            const network = args[3] !== "localhost" ? args[3] : undefined;
            const privateKey = args[4];
            const silent = args[5] === 'true';
            const outPath = args[6];
            const buildInfoPath = args[7];
            const withdrawFunds = args[8] === 'true';
            let newOwner = args[9];
            const ipfsUrl = args[10] !== "none" ? args[9] : undefined;
            const noCompile = true;
            const confirm = false;
            const logPath = `reforge/logs/${network !== null && network !== void 0 ? network : "anvil"}`;
            if (!fs.existsSync(logPath)) {
                fs.mkdirSync(logPath, { recursive: true });
            }
            const now = new Date();
            const logWriter = fs.createWriteStream(`${logPath}/${now.toISOString()}`);
            const { artifactFolder, buildInfoFolder, deploymentFolder, canonicalConfigPath } = (0, utils_1.fetchPaths)(outPath, buildInfoPath);
            const userConfig = (0, core_1.readUserChugSplashConfig)(configPath);
            const artifactPaths = await (0, utils_1.getArtifactPaths)(userConfig.contracts, artifactFolder, buildInfoFolder);
            const provider = new ethers_1.ethers.providers.JsonRpcProvider(rpcUrl, network);
            const wallet = new ethers_1.ethers.Wallet(privateKey, provider);
            await provider.getNetwork();
            const address = await wallet.getAddress();
            newOwner = newOwner !== "self" ? newOwner : address;
            const remoteExecution = args[3] !== 'localhost';
            const spinner = (0, ora_1.default)({ isSilent: silent, stream: logWriter });
            logWriter.write("-- Reforge Deploy --\n");
            let executor;
            if (remoteExecution) {
                spinner.start('Waiting for the executor to set up Reforge...');
                await (0, core_1.monitorChugSplashSetup)(provider, wallet);
            }
            else {
                spinner.start('Booting up Reforge...');
                executor = await (0, utils_1.initializeExecutor)(provider, privateKey, "error");
            }
            spinner.succeed('Reforge is ready to go.');
            const contractArtifacts = await (0, core_1.chugsplashDeployAbstractTask)(provider, wallet, configPath, silent, remoteExecution, ipfsUrl, noCompile, confirm, withdrawFunds, newOwner !== null && newOwner !== void 0 ? newOwner : await wallet.getAddress(), artifactPaths, buildInfoFolder, artifactFolder, canonicalConfigPath, deploymentFolder, 'foundry', executor, logWriter);
            const artifactStructABI = 'tuple(string referenceName, string contractName, address contractAddress)[]';
            const encodedArtifacts = ethers_1.ethers.utils.AbiCoder.prototype.encode([artifactStructABI], [contractArtifacts]);
            process.stdout.write(encodedArtifacts);
            break;
        }
        case 'monitor': {
            const configPath = args[1];
            const rpcUrl = args[2];
            const network = args[3] !== "localhost" ? args[3] : undefined;
            const privateKey = args[4];
            const silent = args[5] === 'true';
            const outPath = args[6];
            const buildInfoPath = args[7];
            const withdrawFunds = args[8] === 'true';
            let newOwner = args[9];
            const { artifactFolder, buildInfoFolder, deploymentFolder, canonicalConfigPath } = (0, utils_1.fetchPaths)(outPath, buildInfoPath);
            const userConfig = (0, core_1.readUserChugSplashConfig)(configPath);
            const artifactPaths = await (0, utils_1.getArtifactPaths)(userConfig.contracts, artifactFolder, buildInfoFolder);
            const provider = new ethers_1.ethers.providers.JsonRpcProvider(rpcUrl, network);
            const wallet = new ethers_1.ethers.Wallet(privateKey, provider);
            await provider.getNetwork();
            const address = await wallet.getAddress();
            newOwner = newOwner !== "self" ? newOwner : address;
            const remoteExecution = args[3] !== 'localhost';
            console.log("-- Reforge Monitor --");
            await (0, core_1.chugsplashMonitorAbstractTask)(provider, wallet, configPath, !withdrawFunds, silent, newOwner, artifactPaths, buildInfoFolder, artifactFolder, canonicalConfigPath, deploymentFolder, "foundry", remoteExecution, process.stdout);
            break;
        }
        case 'cancel': {
            const configPath = args[1];
            const rpcUrl = args[2];
            const network = args[3] !== "localhost" ? args[3] : undefined;
            const privateKey = args[4];
            const outPath = args[5];
            const buildInfoPath = args[6];
            const { artifactFolder, buildInfoFolder, deploymentFolder, canonicalConfigPath } = (0, utils_1.fetchPaths)(outPath, buildInfoPath);
            const userConfig = (0, core_1.readUserChugSplashConfig)(configPath);
            const artifactPaths = await (0, utils_1.getArtifactPaths)(userConfig.contracts, artifactFolder, buildInfoFolder);
            const provider = new ethers_1.ethers.providers.JsonRpcProvider(rpcUrl, network);
            const wallet = new ethers_1.ethers.Wallet(privateKey, provider);
            await provider.getNetwork();
            await wallet.getAddress();
            console.log("-- Reforge Cancel --");
            await (0, core_1.chugsplashCancelAbstractTask)(provider, wallet, configPath, artifactPaths, "foundry", process.stdout);
            break;
        }
        case 'withdraw': {
            const configPath = args[1];
            const rpcUrl = args[2];
            const network = args[3] !== "localhost" ? args[3] : undefined;
            const privateKey = args[4];
            const silent = args[5] === 'true';
            const outPath = args[6];
            const buildInfoPath = args[7];
            const { artifactFolder, buildInfoFolder, canonicalConfigPath } = (0, utils_1.fetchPaths)(outPath, buildInfoPath);
            const userConfig = (0, core_1.readUserChugSplashConfig)(configPath);
            const artifactPaths = await (0, utils_1.getArtifactPaths)(userConfig.contracts, artifactFolder, buildInfoFolder);
            const provider = new ethers_1.ethers.providers.JsonRpcProvider(rpcUrl, network);
            const wallet = new ethers_1.ethers.Wallet(privateKey, provider);
            await provider.getNetwork();
            await wallet.getAddress();
            console.log("-- Reforge Withdraw --");
            await (0, core_1.chugsplashWithdrawAbstractTask)(provider, wallet, configPath, silent, artifactPaths, buildInfoFolder, artifactFolder, canonicalConfigPath, "foundry", process.stdout);
            break;
        }
        case 'listProjects': {
            const rpcUrl = args[1];
            const network = args[2] !== "localhost" ? args[2] : undefined;
            const privateKey = args[3];
            const provider = new ethers_1.ethers.providers.JsonRpcProvider(rpcUrl, network);
            const wallet = new ethers_1.ethers.Wallet(privateKey, provider);
            await provider.getNetwork();
            await wallet.getAddress();
            console.log("-- Reforge List Projects --");
            await (0, core_1.chugsplashListProjectsAbstractTask)(provider, wallet, "foundry", process.stdout);
            break;
        }
        case 'listProposers': {
            const configPath = args[1];
            const rpcUrl = args[2];
            const network = args[3] !== "localhost" ? args[3] : undefined;
            const privateKey = args[4];
            const outPath = args[5];
            const buildInfoPath = args[6];
            const { artifactFolder, buildInfoFolder } = (0, utils_1.fetchPaths)(outPath, buildInfoPath);
            const userConfig = (0, core_1.readUserChugSplashConfig)(configPath);
            const artifactPaths = await (0, utils_1.getArtifactPaths)(userConfig.contracts, artifactFolder, buildInfoFolder);
            const provider = new ethers_1.ethers.providers.JsonRpcProvider(rpcUrl, network);
            const wallet = new ethers_1.ethers.Wallet(privateKey, provider);
            await provider.getNetwork();
            await wallet.getAddress();
            console.log("-- Reforge List Proposers --");
            await (0, core_1.chugsplashListProposersAbstractTask)(provider, wallet, configPath, artifactPaths, "foundry");
            break;
        }
        case 'addProposer': {
            const configPath = args[1];
            const rpcUrl = args[2];
            const network = args[3] !== "localhost" ? args[3] : undefined;
            const privateKey = args[4];
            const outPath = args[5];
            const buildInfoPath = args[6];
            const newProposer = args[7];
            const { artifactFolder, buildInfoFolder } = (0, utils_1.fetchPaths)(outPath, buildInfoPath);
            const userConfig = (0, core_1.readUserChugSplashConfig)(configPath);
            const artifactPaths = await (0, utils_1.getArtifactPaths)(userConfig.contracts, artifactFolder, buildInfoFolder);
            const provider = new ethers_1.ethers.providers.JsonRpcProvider(rpcUrl, network);
            const wallet = new ethers_1.ethers.Wallet(privateKey, provider);
            await provider.getNetwork();
            await wallet.getAddress();
            console.log("-- Reforge Add Proposer --");
            await (0, core_1.chugsplashAddProposersAbstractTask)(provider, wallet, configPath, [newProposer], artifactPaths, "foundry", process.stdout);
            break;
        }
        case 'claimProxy': {
            const configPath = args[1];
            const rpcUrl = args[2];
            const network = args[3] !== "localhost" ? args[3] : undefined;
            const privateKey = args[4];
            const silent = args[5] === 'true';
            const outPath = args[6];
            const buildInfoPath = args[7];
            const referenceName = args[8];
            const { artifactFolder, buildInfoFolder } = (0, utils_1.fetchPaths)(outPath, buildInfoPath);
            const userConfig = (0, core_1.readUserChugSplashConfig)(configPath);
            const artifactPaths = await (0, utils_1.getArtifactPaths)(userConfig.contracts, artifactFolder, buildInfoFolder);
            const provider = new ethers_1.ethers.providers.JsonRpcProvider(rpcUrl, network);
            const wallet = new ethers_1.ethers.Wallet(privateKey, provider);
            await provider.getNetwork();
            await wallet.getAddress();
            console.log("-- Reforge Claim Proxy --");
            await (0, core_1.chugsplashClaimProxyAbstractTask)(provider, wallet, configPath, referenceName, silent, artifactPaths, "foundry", process.stdout);
            break;
        }
        case 'transferProxy': {
            const configPath = args[1];
            const rpcUrl = args[2];
            const network = args[3] !== "localhost" ? args[3] : undefined;
            const privateKey = args[4];
            const silent = args[5] === 'true';
            const outPath = args[6];
            const buildInfoPath = args[7];
            const proxyAddress = args[8];
            const { artifactFolder, buildInfoFolder } = (0, utils_1.fetchPaths)(outPath, buildInfoPath);
            const userConfig = (0, core_1.readUserChugSplashConfig)(configPath);
            const artifactPaths = await (0, utils_1.getArtifactPaths)(userConfig.contracts, artifactFolder, buildInfoFolder);
            const provider = new ethers_1.ethers.providers.JsonRpcProvider(rpcUrl, network);
            const wallet = new ethers_1.ethers.Wallet(privateKey, provider);
            await provider.getNetwork();
            await wallet.getAddress();
            console.log("-- Reforge Transfer Proxy --");
            await (0, core_1.chugsplashTransferOwnershipAbstractTask)(provider, wallet, configPath, proxyAddress, silent, artifactPaths, "foundry", process.stdout);
            break;
        }
    }
})().catch((err) => {
    console.error(err);
    process.stdout.write('');
});
//# sourceMappingURL=index.js.map
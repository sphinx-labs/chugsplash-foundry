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
Object.defineProperty(exports, "__esModule", { value: true });
exports.fetchPaths = exports.getArtifactPaths = exports.getContractArtifact = exports.getBuildInfo = exports.initializeExecutor = void 0;
const core_1 = require("@chugsplash/core");
const executor_1 = require("@chugsplash/executor");
const path = __importStar(require("path"));
const fs = __importStar(require("fs"));
const initializeExecutor = async (provider, privateKey, logLevel) => {
    const executor = new executor_1.ChugSplashExecutor();
    await executor.setup({
        privateKey,
        logLevel,
    }, false, provider);
    return executor;
};
exports.initializeExecutor = initializeExecutor;
const getBuildInfo = (buildInfoFolder, sourceName) => {
    var _a;
    const completeFilePath = path.join(buildInfoFolder);
    const inputs = fs
        .readdirSync(completeFilePath)
        .filter((file) => {
        return file.endsWith('.json');
    })
        .map((file) => {
        return JSON.parse(fs.readFileSync(path.join(buildInfoFolder, file), 'utf8'));
    });
    for (const input of inputs) {
        if (((_a = input === null || input === void 0 ? void 0 : input.output) === null || _a === void 0 ? void 0 : _a.sources[sourceName]) !== undefined) {
            return input;
        }
    }
    throw new Error(`Failed to find build info for ${sourceName}. Are you sure your contracts were compiled and ${buildInfoFolder} is the correct build info directory?`);
};
exports.getBuildInfo = getBuildInfo;
const getContractArtifact = (name, artifactFilder) => {
    const folderName = `${name}.sol`;
    const fileName = `${name}.json`;
    const completeFilePath = path.join(artifactFilder, folderName, fileName);
    const artifact = JSON.parse(fs.readFileSync(completeFilePath, 'utf8'));
    return (0, core_1.parseFoundryArtifact)(artifact);
};
exports.getContractArtifact = getContractArtifact;
const getArtifactPaths = async (contractConfigs, artifactFolder, buildInfoFolder) => {
    const artifactPaths = {};
    for (const { contract } of Object.values(contractConfigs)) {
        const { sourceName, contractName } = (0, exports.getContractArtifact)(contract, artifactFolder);
        const buildInfo = await (0, exports.getBuildInfo)(buildInfoFolder, sourceName);
        const folderName = `${contractName}.sol`;
        const fileName = `${contractName}.json`;
        const contractArtifactPath = path.join(artifactFolder, folderName, fileName);
        artifactPaths[contract] = {
            buildInfoPath: path.join(buildInfoFolder, `${buildInfo.id}.json`),
            contractArtifactPath
        };
    }
    return artifactPaths;
};
exports.getArtifactPaths = getArtifactPaths;
const fetchPaths = (outPath, buildInfoPath) => {
    const artifactFolder = path.resolve(outPath);
    const buildInfoFolder = path.resolve(buildInfoPath);
    const deploymentFolder = path.join('reforge', 'deployments');
    const canonicalConfigPath = path.join('reforge', '.canonical-configs');
    return { artifactFolder, buildInfoFolder, deploymentFolder, canonicalConfigPath };
};
exports.fetchPaths = fetchPaths;
//# sourceMappingURL=index.js.map
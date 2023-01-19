import { ArtifactPaths, BuildInfo, ChugSplashExecutorType, ContractArtifact, UserContractConfigs } from "@chugsplash/core";
import { ethers } from "ethers";
type LogLevel = "trace" | "debug" | "info" | "warn" | "error" | "fatal";
export declare const initializeExecutor: (provider: ethers.providers.JsonRpcProvider, privateKey: string, logLevel: LogLevel) => Promise<ChugSplashExecutorType>;
export declare const getBuildInfo: (buildInfoFolder: string, sourceName: string) => BuildInfo;
export declare const getContractArtifact: (name: string, artifactFilder: string) => ContractArtifact;
export declare const getArtifactPaths: (contractConfigs: UserContractConfigs, artifactFolder: string, buildInfoFolder: string) => Promise<ArtifactPaths>;
export declare const fetchPaths: (outPath: string, buildInfoPath: string) => {
    artifactFolder: string;
    buildInfoFolder: string;
    deploymentFolder: string;
    canonicalConfigPath: string;
};
export {};

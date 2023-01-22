import { ArtifactPaths, BuildInfo, ChugSplashExecutorType, ContractArtifact, Integration, parseFoundryArtifact, UserContractConfigs } from "@chugsplash/core"
import { ChugSplashExecutor } from "@chugsplash/executor"

import { ethers } from "ethers"
import * as path from 'path'
import * as fs from 'fs'

type LogLevel = "trace" | "debug" | "info" | "warn" | "error" | "fatal"

export const initializeExecutor = async (provider: ethers.providers.JsonRpcProvider, privateKey: string, logLevel: LogLevel) => {
    // Instantiate the executor.
    const executor = new ChugSplashExecutor()

    // Setup the executor.
    await executor.setup(
        {
        privateKey,
        logLevel,
        },
        false,
        provider
    )

    // forgive my sins
    return executor as any as ChugSplashExecutorType
}

export const getBuildInfo = (
    buildInfoFolder: string,
    sourceName: string
): BuildInfo => {
    const completeFilePath = path.join(buildInfoFolder)

    // Get the inputs from the build info folder.
    const inputs = fs
        .readdirSync(completeFilePath)
        .filter((file) => {
            return file.endsWith('.json')
        })
        .map((file) => {
            return JSON.parse(
                fs.readFileSync(path.join(buildInfoFolder, file), 'utf8')
            )
        })
    
    // Find the correct build info file
    for (const input of inputs) {
        if (input?.output?.sources[sourceName] !== undefined) {
            return input
        }
    }
    
    throw new Error(
        `Failed to find build info for ${sourceName}. Please check that you:
1. Imported this file in your script
2. Set 'force=true' in your foundry.toml
3. Check that ${buildInfoFolder} is the correct build info directory.`
    )
}

export const getContractArtifact = (
    name: string,
    artifactFilder: string,
): ContractArtifact => {
    const folderName = `${name}.sol`
    const fileName = `${name}.json`
    const completeFilePath = path.join(artifactFilder, folderName, fileName)

    if (!fs.existsSync(completeFilePath)) {
      throw new Error(`Could not find artifact for: ${name}. Did you forget to import it in your script file?`)
    }

    const artifact = JSON.parse(fs.readFileSync(completeFilePath, 'utf8'))

    return parseFoundryArtifact(artifact)
}

export const getArtifactPaths = async (
    contractConfigs: UserContractConfigs,
    artifactFolder: string,
    buildInfoFolder: string,
): Promise<ArtifactPaths> => {
    const artifactPaths: ArtifactPaths = {}
  
    for (const { contract } of Object.values(contractConfigs)) {
        const { sourceName, contractName } = getContractArtifact(contract, artifactFolder)
        const buildInfo = await getBuildInfo(buildInfoFolder, sourceName)

        const folderName = `${contractName}.sol`
        const fileName = `${contractName}.json`
        const contractArtifactPath = path.join(artifactFolder, folderName, fileName)

        artifactPaths[contract] = {
            buildInfoPath: path.join(buildInfoFolder, `${buildInfo.id}.json`),
            contractArtifactPath
        }
    }
    return artifactPaths
}

export const cleanPath = (path: string) => {
    let cleanQuotes = path.replace(/'/g, "")
    cleanQuotes = cleanQuotes.replace(/"/g, "")
    return cleanQuotes.trim();
}

export const fetchPaths = (outPath: string, buildInfoPath: string) => {
    const artifactFolder = path.resolve(outPath)
    const buildInfoFolder = path.resolve(buildInfoPath)
    const deploymentFolder = path.join('chugsplash', 'deployments')
    const canonicalConfigPath = path.join('chugsplash', '.canonical-configs')

    return { artifactFolder, buildInfoFolder, deploymentFolder, canonicalConfigPath }
}
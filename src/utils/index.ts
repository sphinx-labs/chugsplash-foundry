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
  let latestTimeCreated = 0
  let latestBuildInfo: BuildInfo | undefined
  for (const fileName of fs.readdirSync(buildInfoFolder)) {
    if (fileName.endsWith('json')) {
      const buildInfo = JSON.parse(
        fs.readFileSync(path.join(buildInfoFolder, fileName), 'utf8')
      )

      if (buildInfo?.output?.sources[sourceName] !== undefined) {
        const timeCreated = fs.statSync(path.join(buildInfoFolder, fileName)).birthtime.getTime()
        if (timeCreated > latestTimeCreated) {
          latestBuildInfo = buildInfo
        }
      }
    }
  }

  if (latestBuildInfo === undefined) {
    throw new Error(`Could not find build info file. Try re-compiling then running the command again.`)
  }

  return latestBuildInfo
}

export const getContractArtifact = (
    name: string,
    artifactFilder: string,
): ContractArtifact => {
    const folderName = `${name}.sol`
    const fileName = `${name}.json`
    const completeFilePath = path.join(artifactFilder, folderName, fileName)
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
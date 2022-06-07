import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployCommitment: DeployFunction = async (
  hre: HardhatRuntimeEnvironment
) => {
  const { deployments, network } = hre;
  const { deploy, log } = deployments;
  const chainId: number = network.config.chainId!;

  if (chainId === 31337) {
    log("Ah this is hardhat");
    // Any Hardhat specific initialization
  } else {
    log("oo are we going to a testnet");
    // Any general network initialization
  }

  log("----------------------------------------------------");
  log("Deploying Commitment and waiting for confirmations...");
};

export default deployCommitment;
deployCommitment.tags = ["all", "commitment"];

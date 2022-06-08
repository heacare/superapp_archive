import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployMocks: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
  const { deployments, network, getNamedAccounts } = hre;
  const { deploy, log } = deployments;

  const { deployer } = await getNamedAccounts();
  const chainId: number = network.config.chainId!;

  // Only deploy mocks on default
  if (chainId === 31337) {
    log("-------------------------------------------------");
    log("Deploying mocks...");
    await deploy("HealthPoint", {
      contract: "HealthPoint",
      from: deployer,
      log: true,
      args: [],
    });

    log("$HP ERC20 token deployed!");
    log("All mocks deployed!");
    log("-------------------------------------------------");
  }
};

export default deployMocks;
deployMocks.tags = ["all", "mocks"];

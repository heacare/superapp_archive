import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployMocks: DeployFunction = async (
  hre: HardhatRuntimeEnvironment
) => {};

export default deployMocks;
deployMocks.tags = ["all", "mocks"];

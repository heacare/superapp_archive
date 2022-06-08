import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployCommitment: DeployFunction = async (
  hre: HardhatRuntimeEnvironment
) => {
  const { deployments, network, getNamedAccounts } = hre;
  const { deploy, log } = deployments;

  const { deployer } = await getNamedAccounts();
  const chainId: number = network.config.chainId!;

  let hpTokenAddr: string;
  if (chainId === 31337) {
    // Any Hardhat specific initialization
    // Get the $HP mock
    const hpToken = await deployments.get("HealthPoint");
    hpTokenAddr = hpToken.address;
  } else {
    log("ERROR: Proper networks not configured");
    return;
    // Any general network initialization
  }

  log("----------------------------------------------------");
  log("Deploying Commitment and waiting for confirmations...");
  const commitmentContract = await deploy("Commitment", {
    contract: "Commitment",
    from: deployer,
    log: true,
    args: [hpTokenAddr],
    waitConfirmations: 1,
  });

  log(`Commitment deployed at ${commitmentContract.address}`);
};

export default deployCommitment;
deployCommitment.tags = ["all", "commitment"];

import "@nomiclabs/hardhat-etherscan";
import { task } from "hardhat/config";
import { BigNumber } from "@ethersproject/bignumber";
import fs from "fs";
import path from "path";
import { HardhatRuntimeEnvironment } from "hardhat/types";

async function verifyContract(
  hre: HardhatRuntimeEnvironment,
  contractAddress: string,
  ctorArgs: string[]
) {
  await hre.run("verify:verify", {
    address: contractAddress,
    constructorArguments: ctorArgs,
  });
}

task("deploy", "deployment").setAction(async (taskArgs, hre) => {
  const BN = BigNumber;
  const [deployer] = await hre.ethers.getSigners();
  const deployerAddress = await deployer.getAddress();
  console.log(`Deployer address: ${deployerAddress}`);

  const factoryAddress = "0x9D4ffbf49cc21372c2115Ae4C155a1e5c0aACf36";
  const wethAddress = "0xB47e6A5f8b33b3F17603C83a0535A9dcD7E32681";

  const Contract = await hre.ethers.getContractFactory("ZapInV2");
  let contract = await Contract.deploy(factoryAddress, wethAddress);
  await contract.deployed();

  const contractAddress = contract.address;

  console.log(`Contract Address: ${contractAddress}`);

  try {
    console.log(`Verify contract at: ${contractAddress}`);
    await verifyContract(hre, contractAddress, [factoryAddress, wethAddress]);
    console.log(`Verify successfully`);
  } catch (e: any) {
    console.log(`Error in verify distributor, ${e.toString()} || continue...`);
  }

  console.log("setup completed");
  process.exit(0);
});

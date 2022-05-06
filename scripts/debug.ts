import "@nomiclabs/hardhat-etherscan";
import { task } from "hardhat/config";
import { BigNumber } from "@ethersproject/bignumber";
import fs from "fs";
import path from "path";
import { HardhatRuntimeEnvironment } from "hardhat/types";

task("debug", "debug").setAction(async (taskArgs, hre) => {
  const STToken = await hre.ethers.getContractFactory("TokenA");
  const stToken = await STToken.attach(
    "0x94870a1fb1E2a9032616262B37F4147A5eb9639e"
  );

  const tx = await stToken.transfer(
    "0xD4FbaBd7fB321C6edf4e19ac39288bdD21799181",
    BigNumber.from(1000).mul(BigNumber.from(10).pow(18))
  );

  await tx.wait();

  console.log("debug completed");
  process.exit(0);
});

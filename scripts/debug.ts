import "@nomiclabs/hardhat-etherscan";
import { task } from "hardhat/config";
import { BigNumber } from "@ethersproject/bignumber";
import fs from "fs";
import path from "path";
import { HardhatRuntimeEnvironment } from "hardhat/types";

task("debug", "debug").setAction(async (taskArgs, hre) => {
  const Pool = await hre.ethers.getContractFactory("KSPool");
  const pool = await Pool.attach("0x8Cc718Bd92b5D8d4cf09364cF30E851dfa9D4e78");

  const ampBps = await pool.ampBps();

  console.log(ampBps);

  const totalSupply = await pool.totalSupply();

  console.log(totalSupply);

  const tradeInfo = await pool.getTradeInfo();

  console.log(tradeInfo);

  console.log("debug completed");
  process.exit(0);
});

import { expect } from "chai";
import { ethers } from "hardhat";
import { BigNumber } from "@ethersproject/bignumber";

describe("PolySwap", function () {
  let decimals = 18;
  let decimal = BigNumber.from(10).pow(decimals);

  let decimals2 = 12;
  let decimal2 = BigNumber.from(10).pow(decimals2);

  let decimals3 = 10;
  let decimal3 = BigNumber.from(10).pow(decimals3);

  let Contract;
  let contract: any;

  let TokenA;
  let tokenA: any;
  let tokenAReserve = BigNumber.from(1).mul(decimal2).mul(decimal);

  let TokenB;
  let tokenB: any;
  let tokenBReserve = BigNumber.from(1).mul(decimal2).mul(decimal);

  let TokenC;
  let tokenC: any;
  let tokenCReserve = BigNumber.from(1).mul(decimal2).mul(decimal);

  let owner: any, addr1: any, addr2;

  //To run these steps before each test scenario.
  beforeEach(async function () {
    //list of account addresses to be used for tests.
    [owner, addr1, addr2] = await ethers.getSigners();
    //to create an instance of kolkaToken &
    // & to deploy it with 30 KOL.

    TokenA = await ethers.getContractFactory("TokenA");
    tokenA = await TokenA.deploy();
    await tokenA.deployed();

    TokenB = await ethers.getContractFactory("TokenB");
    tokenB = await TokenB.deploy();
    await tokenB.deployed();

    TokenC = await ethers.getContractFactory("TokenC");
    tokenC = await TokenC.deploy();
    await tokenC.deployed();

    Contract = await ethers.getContractFactory("PolySwap");
    contract = await Contract.deploy(
      [tokenA.address, tokenB.address, tokenC.address],
      [
        BigNumber.from(1).mul(decimal),
        BigNumber.from(1).mul(decimal),
        BigNumber.from(1).mul(decimal),
      ],
      [
        BigNumber.from(0).mul(decimal),
        BigNumber.from(0).mul(decimal),
        BigNumber.from(0).mul(decimal),
      ],
      [
        BigNumber.from(2).pow(63).mul(decimal),
        BigNumber.from(2).pow(63).mul(decimal),
        BigNumber.from(2).pow(63).mul(decimal),
      ],
      [tokenAReserve, tokenBReserve, tokenCReserve],
      BigNumber.from(1).mul(decimal3).mul(decimal),
      BigNumber.from(1).mul(decimal3).mul(decimal),
      BigNumber.from(10000),
      BigNumber.from(0),
      BigNumber.from(0)
    );
    await contract.deployed();

    const tx1 = await tokenA.transfer(contract.address, tokenAReserve);
    await tx1.wait();

    const tx2 = await tokenB.transfer(contract.address, tokenBReserve);
    await tx2.wait();

    const tx3 = await tokenC.transfer(contract.address, tokenCReserve);
    await tx3.wait();
  });

  it("PolySwap: Swap Exact Token For Token", async function () {
    const swapAmountIn = BigNumber.from(845707394643).mul(decimal);
    const swapAmountOutMin = BigNumber.from(0);
    // const balanceTokenInAfterSwap = BigNumber.from(998900).mul(decimal);
    // const balanceTokenOutAfterSwap = "999023598611012685139043"; // manual calculated

    const approveTx = await tokenA.approve(contract.address, swapAmountIn);
    await approveTx.wait();

    const swapTx = await contract.swapExactTokenForToken([
      tokenA.address,
      tokenB.address,
      swapAmountIn,
      swapAmountOutMin,
    ]);

    const receipt = await swapTx.wait();

    console.log(await tokenA.balanceOf(owner.address));
    console.log(await tokenB.balanceOf(owner.address));

    // expect(await tokenA.balanceOf(owner.address)).to.be.equals(
    //   balanceTokenInAfterSwap
    // );
    // expect(await tokenB.balanceOf(owner.address)).to.be.equals(
    //   balanceTokenOutAfterSwap
    // );

    console.log("Swap Exact Token for Token, Gas used: %s", receipt.gasUsed);
  });
});

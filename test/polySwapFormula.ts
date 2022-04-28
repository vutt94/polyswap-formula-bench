import { expect } from "chai";
import { ethers } from "hardhat";
import { BigNumber } from "@ethersproject/bignumber";

describe("PolySwap", function () {
  let Contract;
  let contract: any;

  let owner: any, addr1: any, addr2;

  const testCases: {
    elements: [BigNumber, BigNumber][];
    initialX: BigNumber;
  }[] = [
    {
      elements: [
        [BigNumber.from(2), BigNumber.from(10)],
        [BigNumber.from(3), BigNumber.from(4)],
        [BigNumber.from(5), BigNumber.from(6)],
      ],
      initialX: BigNumber.from(4),
    },
    {
      elements: [
        [BigNumber.from(2), BigNumber.from(10)],
        [BigNumber.from(3), BigNumber.from(4)],
        [BigNumber.from(5), BigNumber.from(6)],
        [BigNumber.from(5), BigNumber.from(16)],
        [BigNumber.from(9), BigNumber.from(10)],
      ],
      initialX: BigNumber.from(14),
    },
  ];

  //To run these steps before each test scenario.
  beforeEach(async function () {
    //list of account addresses to be used for tests.
    [owner, addr1, addr2] = await ethers.getSigners();
    //to create an instance of kolkaToken &
    // & to deploy it with 30 KOL.
    Contract = await ethers.getContractFactory("PolySwapFormula");
    contract = await Contract.deploy();
    await contract.deployed();
  });

  it("PolySwap: Newton Method", async function () {
    const results: { result: BigNumber; gasUsed: BigNumber }[] = [];

    const tx = await contract.standardFormulaNewton(
      testCases[0].slice(0, 3) as [[BigNumber, BigNumber]],
      testCases[0][3],
      testCases[0][4]
    );
    const receipt = await tx.wait();
    results.push({
      result: await contract.standardNewtonResult(),
      gasUsed: receipt.gasUsed,
    });

    const tx1 = await contract.standardFormulaNewton(
      testCases[1].slice(0, 3) as [[BigNumber, BigNumber]],
      testCases[1][3],
      testCases[1][4]
    );
    const receipt1 = await tx1.wait();
    results.push({
      result: await contract.standardNewtonResult(),
      gasUsed: receipt1.gasUsed,
    });

    console.log(results);

    expect(true).to.be.equals(true);
  });

  it("PolySwap: Halley Method", async function () {
    const results: { result: BigNumber; gasUsed: BigNumber }[] = [];

    const tx = await contract.standardFormulaHalley(
      testCases[0].slice(0, 3) as [[BigNumber, BigNumber]],
      testCases[0][3],
      testCases[0][4]
    );
    const receipt = await tx.wait();
    results.push({
      result: await contract.standardHalleyResult(),
      gasUsed: receipt.gasUsed,
    });

    const tx1 = await contract.standardFormulaHalley(
      testCases[1].slice(0, 3) as [[BigNumber, BigNumber]],
      testCases[1][3],
      testCases[1][4]
    );
    const receipt1 = await tx1.wait();
    results.push({
      result: await contract.standardHalleyResult(),
      gasUsed: receipt1.gasUsed,
    });

    console.log(results);

    expect(true).to.be.equals(true);
  });

  it("PolySwap: Approximation Formula Newton Method", async function () {
    const results: { result: BigNumber; gasUsed: BigNumber }[] = [];

    const tx = await contract.appFormulaNewton(
      testCases[0].slice(0, 3) as [[BigNumber, BigNumber]],
      testCases[0][4]
    );
    const receipt = await tx.wait();
    results.push({
      result: await contract.appNewtonResult(),
      gasUsed: receipt.gasUsed,
    });

    const tx1 = await contract.appFormulaNewton(
      testCases[1].slice(0, 3) as [[BigNumber, BigNumber]],
      testCases[1][4]
    );
    const receipt1 = await tx1.wait();
    results.push({
      result: await contract.appNewtonResult(),
      gasUsed: receipt1.gasUsed,
    });

    console.log(results);

    expect(true).to.be.equals(true);
  });

  it("PolySwap: Approximation Formula Halley Method", async function () {
    const results: { result: BigNumber; gasUsed: BigNumber }[] = [];

    const tx = await contract.appFormulaHalley(
      testCases[0].slice(0, 3) as [[BigNumber, BigNumber]],
      testCases[0][4]
    );
    const receipt = await tx.wait();
    results.push({
      result: await contract.appHalleyResult(),
      gasUsed: receipt.gasUsed,
    });

    const tx1 = await contract.appFormulaHalley(
      testCases[1].slice(0, 3) as [[BigNumber, BigNumber]],
      testCases[1][4]
    );
    const receipt1 = await tx1.wait();
    results.push({
      result: await contract.appHalleyResult(),
      gasUsed: receipt1.gasUsed,
    });

    console.log(results);

    expect(true).to.be.equals(true);
  });
});

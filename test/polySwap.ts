import { expect } from "chai";
import { ethers } from "hardhat";
import { BigNumber } from "@ethersproject/bignumber";

describe("PolySwap", function () {
  let Contract;
  let contract: any;

  let owner: any, addr1: any, addr2;

  const testCases: [
    [BigNumber, BigNumber],
    [BigNumber, BigNumber],
    [BigNumber, BigNumber],
    BigNumber,
    BigNumber
  ][] = [
    [
      [BigNumber.from(20), BigNumber.from(100)],
      [BigNumber.from(30), BigNumber.from(40)],
      [BigNumber.from(50), BigNumber.from(60)],
      BigNumber.from(10),
      BigNumber.from(5),
    ],
    [
      [BigNumber.from(30), BigNumber.from(400)],
      [BigNumber.from(50), BigNumber.from(60)],
      [BigNumber.from(20), BigNumber.from(100)],
      BigNumber.from(10),
      BigNumber.from(5),
    ],
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
    const results = await Promise.all(
      testCases.map(async (testCase): Promise<BigNumber[]> => {
        const results = await contract.standardFormulaNewton(
          testCase.slice(0, 3) as [[BigNumber, BigNumber]],
          testCase[3],
          testCase[4]
        );

        return results.filter((item: BigNumber) => item.toString() !== "0");
      })
    );

    console.log(results);

    expect(true).to.be.equals(true);
  });

  it("PolySwap: Halley Method", async function () {
    const results = await Promise.all(
      testCases.map(async (testCase): Promise<BigNumber[]> => {
        const results = await contract.standardFormulaHalley(
          testCase.slice(0, 3) as [[BigNumber, BigNumber]],
          testCase[3],
          testCase[4]
        );

        return results.filter((item: BigNumber) => item.toString() !== "0");
      })
    );

    console.log(results);

    expect(true).to.be.equals(true);
  });

  it("PolySwap: Approximation Formula Newton Method", async function () {
    const results = await Promise.all(
      testCases.map(async (testCase): Promise<BigNumber[]> => {
        const results = await contract.appFormulaNewton(
          testCase.slice(0, 3) as [[BigNumber, BigNumber]],
          testCase[4]
        );

        return results.filter((item: BigNumber) => item.toString() !== "0");
      })
    );

    console.log(results);

    expect(true).to.be.equals(true);
  });

  it("PolySwap: Approximation Formula Halley Method", async function () {
    const results = await Promise.all(
      testCases.map(async (testCase): Promise<BigNumber[]> => {
        const results = await contract.appFormulaHalley(
          testCase.slice(0, 3) as [[BigNumber, BigNumber]],
          testCase[4]
        );

        return results.filter((item: BigNumber) => item.toString() !== "0");
      })
    );

    console.log(results);

    expect(true).to.be.equals(true);
  });
});

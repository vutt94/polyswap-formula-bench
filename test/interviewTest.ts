import { expect } from "chai";
import { ethers } from "hardhat";
import { BigNumber } from "@ethersproject/bignumber";

describe("BasicERC20", function () {
  let BasicERC20;
  let basicERC20: any;
  const decimals = 18;
  const decimal = BigNumber.from(10).pow(decimals);
  const initSupply = BigNumber.from(30).mul(decimal);
  let owner: any, addr1: any, addr2;
  //To run these steps before each test scenario.
  beforeEach(async function () {
    //list of account addresses to be used for tests.
    [owner, addr1, addr2] = await ethers.getSigners();
    //to create an instance of kolkaToken &
    // & to deploy it with 30 KOL.
    BasicERC20 = await ethers.getContractFactory("BasicERC20");
    basicERC20 = await BasicERC20.deploy("Test", "TST", 18);
    await basicERC20.deployed();
    //Verifying the total supply & the balances of test accounts.
    expect(await basicERC20.totalSupply()).to.equal(initSupply);
    expect(await basicERC20.balanceOf(owner.address)).to.equal(initSupply);
    expect(await basicERC20.balanceOf(addr1.address)).to.equal(0);
    expect(await basicERC20.balanceOf(addr2.address)).to.equal(0);
  });

  it("Test: Token Attributes", async function () {
    //Verifying the name of the token
    expect(await basicERC20.name()).to.equal("Test");
    //Verifying the symbol of the token
    expect(await basicERC20.symbol()).to.equal("TST");
    //Verifying the decimals of the token.
    expect(await basicERC20.decimals()).to.equal(18);
  });

  //To test the Transfer  function in this scenario.
  it("Test: transfer 1", async function () {
    //transfer 10 KOL from owner to addr1.
    //Verifying the event generated after the transfer execution.
    await basicERC20.transfer(addr1.address, BigNumber.from(10).mul(decimal));
    //verifying the balances of owner and addr1 and the total supply after the transfer.
    expect(await basicERC20.balanceOf(addr1.address)).to.equal(
      BigNumber.from(10).mul(decimal)
    );
    expect(await basicERC20.balanceOf(owner.address)).to.equal(
      BigNumber.from(20).mul(decimal)
    );
    expect(await basicERC20.totalSupply()).to.equal(
      BigNumber.from(30).mul(decimal)
    );
  });
});

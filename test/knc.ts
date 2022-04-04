import { expect } from "chai";
import { ethers } from "hardhat";
import { BigNumber } from "@ethersproject/bignumber";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { Contract } from "ethers";

describe("KNC", function () {
  const decimals = 18;
  const decimal = BigNumber.from(10).pow(decimals);
  const tokenName = "Kyber Network";
  const tokenSymbol = "KNC";
  const maxTotalSupply = BigNumber.from(1000000000).mul(decimal);
  let TokenContract;
  let token: Contract;
  let owner: SignerWithAddress;
  let addr1: SignerWithAddress;
  let addr2;
  let addr3;
  let addrs;

  beforeEach(async function () {
    [owner, addr1, addr2, addr3, ...addrs] = await ethers.getSigners();

    TokenContract = await ethers.getContractFactory("KNC");
    token = await TokenContract.deploy(tokenName, tokenSymbol, maxTotalSupply);
    await token.deployed();
  });

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      expect(await token.owner()).to.equal(owner.address);
    });

    it("Should set the right name", async function () {
      expect(await token.name()).to.equal(tokenName);
    });

    it("Should set the right symbol", async function () {
      expect(await token.symbol()).to.equal(tokenSymbol);
    });

    it("Should set the right decimals", async function () {
      expect(await token.decimals()).to.equal(decimals);
    });

    it("Should set the right max total supply", async function () {
      expect(await token.maxTotalSupply()).to.equal(maxTotalSupply);
    });
  });

  describe("Mint and Burn", function () {
    it("allow owner to mint token", async function () {
      const amountToMint = BigNumber.from(1000).mul(decimal);
      const mintTx = await token.mint(owner.address, amountToMint);
      await mintTx.wait();

      expect(await token.balanceOf(owner.address)).to.equal(amountToMint);
    });

    it("not allow someone else to mint token", async function () {
      const amountToMint = BigNumber.from(1000).mul(decimal);
      const mintTx = await token.mint(addr1.address, amountToMint);

      await expect(
        token.connect(addr1).mint(addr1.address, amountToMint)
      ).to.be.revertedWith("Ownable: caller is not the owner");
    });

    it("allow sender to burn their token", async function () {
      const amountToMint = BigNumber.from(1000).mul(decimal);
      const mintTx = await token.mint(owner.address, amountToMint);
      await mintTx.wait();

      expect(await token.balanceOf(owner.address)).to.equal(amountToMint);

      const amountToBurn = BigNumber.from(1000).mul(decimal);
      const burnTx = await token.burn(amountToBurn);
      await burnTx.wait();

      expect(await token.balanceOf(owner.address)).to.equal(0);
    });
  });
});

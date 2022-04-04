const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NFTMarketplace", function () {
  it("Should return the new greeting once it's changed", async function () {
    const NFTMarketplace = await ethers.getContractFactory("NFTMarketplace");
    const nftmarketplace = await NFTMarketplace.deploy();
    await nftmarketplace.deployed();

    expect(await nftmarketplace.getNFTMarketplace()).to.equal("Hello, world!");

  });
});

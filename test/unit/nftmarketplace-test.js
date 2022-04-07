const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NFTMarketplace", function () {

  // before each. assign global variables. deploy system in fatse
  it("Should return the NFT marketplace listing at given index", async function () {
    const NFTMarketplace = await ethers.getContractFactory("NFTMarketplace");
    const nftmarketplace = await NFTMarketplace.deploy();
    await nftmarketplace.deployed();

    expect(await nftmarketplace.getLengthMarketplace()).to.equal(0);

  });
});

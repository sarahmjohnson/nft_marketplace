const { expect } = require("chai");
const { ethers } = require("hardhat");

const ROYALTY = 10;

describe("NFT", function () {
    
    let hardhatNFT;

    beforeEach(async function () {

        items = await ethers.getSigners();
        const HardhatNFT = await ethers.getContractFactory("NFT");
        hardhatNFT = await HardhatNFT.deploy();
        await hardhatNFT.deployed();

        const HardhatNFTMarketplace = await ethers.getContractFactory("NFTMarketplace");
        hardhatNFTMarketplace = await HardhatNFTMarketplace.deploy(hardhatNFT.address);
        await hardhatNFTMarketplace.deployed();

        [address1] = await ethers.getSigners();

        marketplaceAddress = hardhatNFTMarketplace.address;

    });

    describe("Mint", function () {

        it("Should mint an NFT", async function () {

            const tx = await hardhatNFT.mint(
                ROYALTY
            )
            const resp = await tx.wait();
    
            tokenId = resp.events[resp.events.length - 1].args.tokenId;

            expect(await tokenId).to.equal(1);


        });
    });

    describe("SetMarketplace", function () {

        it("Should set the marketplace if not already set or not item owner", async function () {

            const tx = await hardhatNFT.mint(
                ROYALTY
            )
            const resp = await tx.wait();
    
            tokenId = resp.events[resp.events.length - 1].args.tokenId;

            const tx1 = await hardhatNFT.setMarketplace(
                tokenId,
                marketplaceAddress
            )

            const resp1 = await tx1.wait();
            const marketplace = await resp1.events[resp1.events.length - 1].args.marketplace;

            expect(marketplace).to.equal(marketplaceAddress);

        });
    });

    describe("Approve", function () {

        it("Should approve transfers on this marketplace", async function () {

            const tx = await hardhatNFT.mint(
                ROYALTY
            )
            const resp = await tx.wait();
    
            tokenId = resp.events[resp.events.length - 1].args.tokenId;

            const tx1 = await hardhatNFT.approveForListing(
                tokenId
            )

            const resp1 = await tx1.wait();
            const tokenIdEmitted = await resp1.events[resp1.events.length - 1].args.tokenId;

            expect(tokenId).to.equal(tokenIdEmitted);

        });
    });


});

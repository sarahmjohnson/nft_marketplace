const { expect } = require("chai");
const { ethers } = require("hardhat");

const ROYALTY = 3;
const SALEPRICE = ethers.utils.parseEther(".0000001");


describe("NFT", function () {
    
    let hardhatNFT;
    let royaltyAddress;
    let royaltyAmount;

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

            royaltyAddress, royaltyArray = await hardhatNFT.royaltyInfo(tokenId, SALEPRICE);
            expect(this.address).to.equal(royaltyAddress);
            
            royaltyToMatch = royaltyArray[1]/SALEPRICE;
            expect(ROYALTY).to.equal(royaltyToMatch*100);

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

            await hardhatNFT.setMarketplace(
                tokenId,
                marketplaceAddress
            )

            await hardhatNFT.approveForListing(
                tokenId
            )

            approvals = await hardhatNFT.getApproved(tokenId);
            expect(approvals).to.equal(marketplaceAddress);

        });
    });


});

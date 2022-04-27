const { messagePrefix } = require("@ethersproject/hash");
const chai = require("chai");
const { expect } = require("chai");
const { ethers } = require("hardhat");

const ROYALTY = 10;
const SALEPRICE = ethers.utils.parseEther(".0000001");
const STARTTIME = 151081246
const EXPIRATIONTIME = 1680898949


describe("NFTMarketplace", function () {
    
    let hardhatNFT;
    let hardhatNFTMarketplace;
    let assert = chai.assert;
    let address1;
    let tokenId;

    async function deployContracts () {

        const HardhatNFT = await ethers.getContractFactory("NFT");
        hardhatNFT = await HardhatNFT.deploy();
        await hardhatNFT.deployed();

        const HardhatNFTMarketplace = await ethers.getContractFactory("NFTMarketplace");
        hardhatNFTMarketplace = await HardhatNFTMarketplace.deploy(hardhatNFT.address);
        await hardhatNFTMarketplace.deployed();

        [address1] = await ethers.getSigners();

        const tx = await hardhatNFT.mint(
            ROYALTY
        )
        const resp = await tx.wait();

        tokenId = resp.events[resp.events.length - 1].args.tokenId;

        await hardhatNFT.setMarketplace(
            tokenId,
            hardhatNFTMarketplace.address
        )

        await hardhatNFT.approveForListing(
            tokenId
        )

    }

    beforeEach(deployContracts)

    describe("addListing", function () {

        it("Should add a listing to the marketplace", async function () {
        
            await hardhatNFTMarketplace.addListing(
                tokenId,
                SALEPRICE,
                STARTTIME,
                EXPIRATIONTIME
            );
            
            // Verify there is only one item in the marketplace
            expect(await hardhatNFTMarketplace.getLengthMarketplace()).to.equal(1);
            
            // Verify the tokenId of the item just added
            const listing0 = await hardhatNFTMarketplace.getListing(0);
            assert(listing0[1], 0);

        });

        it("Should make an offer on a marketplace item", async function () {

            await hardhatNFTMarketplace.addListing(
                tokenId,
                SALEPRICE,
                STARTTIME,
                EXPIRATIONTIME
            );

            // Get the listingId
            const listing0 = await hardhatNFTMarketplace.getListing(0);
            const listingId = listing0[0]

            await hardhatNFTMarketplace.makeOffer(
                listingId,
                {value: ethers.utils.parseEther(".0000001")}
            );

            // Check isSold set to true
            const listing = await hardhatNFTMarketplace.getListing(0);
            assert(listing[6]);

        });

    });
});

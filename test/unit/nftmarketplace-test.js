const { messagePrefix } = require("@ethersproject/hash");
const chai = require("chai");
const { expect } = require("chai");
const { ethers } = require("hardhat");

const TOKENURI = "https://easyupload.io/z0bw53";
const ROYALTY = 10;
const SALEPRICE = 20;
const STARTTIME = 1649362949
const EXPIRATIONTIME = 1680898949


describe("NFTMarketplace", function () {
    
    let hardhatNFT;
    let hardhatNFTMarketplace;
    let assert = chai.assert;
    let address1;

    async function deployContracts () {

        const HardhatNFT = await ethers.getContractFactory("NFT");
        hardhatNFT = await HardhatNFT.deploy();
        await hardhatNFT.deployed();

        const HardhatNFTMarketplace = await ethers.getContractFactory("NFTMarketplace");
        hardhatNFTMarketplace = await HardhatNFTMarketplace.deploy(hardhatNFT.address);
        await hardhatNFTMarketplace.deployed();

        [address1] = await ethers.getSigners();

        marketplaceAddress = await hardhatNFT.setMarketplace(hardhatNFTMarketplace.address);

        const resp = await hardhatNFT.mint(
            TOKENURI,
            ROYALTY
        )

        tokenId = resp.value;

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

            // get the listingId
            const listing0 = await hardhatNFTMarketplace.getListing(0);
            const listingId = listing0[0]

            await hardhatNFTMarketplace.makeOffer(
                listingId,
                {value: ethers.utils.parseEther("1")}
            );

        });

    });
});

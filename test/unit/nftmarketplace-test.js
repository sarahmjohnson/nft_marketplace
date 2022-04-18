const chai = require("chai");
const { expect } = require("chai");
const { ethers } = require("hardhat");

const TOKENID = 2390483209;
const CONTRACTADDRESS = "0xb8b44b60085E9eB2BAefAc59E191a66D8294dD49";
const ROYALTY = 10;
const SALEPRICE = 20;
const STARTTIME = 1649362949
const EXPIRATIONTIME = 1680898949


describe("NFTMarketplace", function () {
    
    let hardhatNFT;
    let hardhatNFTMarketplace;
    let assert = chai.assert;
    let itemId;

    async function deployContracts () {

        const HardhatNFT = await ethers.getContractFactory("NFT");
        hardhatNFT = await HardhatNFT.deploy();
        await hardhatNFT.deployed();

        const HardhatNFTMarketplace = await ethers.getContractFactory("NFTMarketplace");
        hardhatNFTMarketplace = await HardhatNFTMarketplace.deploy(hardhatNFT.address);
        await hardhatNFTMarketplace.deployed();

        await ethers.getSigners();

        const resp = await hardhatNFT.mint(
            TOKENID,
            CONTRACTADDRESS,
            ROYALTY
        )

        itemId = resp.value;
    }

    beforeEach(deployContracts)


    describe("addListing", function () {

        it("Should add a listing to the marketplace", async function () {
        
            await hardhatNFTMarketplace.addListing(
                itemId,
                SALEPRICE,
                STARTTIME,
                EXPIRATIONTIME
            );
            
            // verify there is only one item in the marketplace
            expect(await hardhatNFTMarketplace.getLengthMarketplace()).to.equal(1);
            
            // verify the itemId of the item just added
            const listing0 = await hardhatNFTMarketplace.getListing(0);
            assert(listing0[1], 0);

        });

        it("Should make an offer on a marketplace item", async function () {

            // TODO: figure out how to unit test with funds being sent

            // await hardhatNFTMarketplace.addListing(
            //     itemId,
            //     SALEPRICE,
            //     STARTTIME,
            //     EXPIRATIONTIME
            // );
            
            // // get the listingId
            // const listing0 = await hardhatNFTMarketplace.getListing(0);
            // const listingId = listing0[0]
        
            // await hardhatNFTMarketplace.makeOffer(
            //     listingId
            // );

        });

    });
});

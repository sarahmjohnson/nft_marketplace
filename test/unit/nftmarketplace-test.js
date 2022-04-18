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

    beforeEach(async function () {

        items = await ethers.getSigners();
        const HardhatNFTMarketplace = await ethers.getContractFactory("NFTMarketplace");
        hardhatNFTMarketplace = await HardhatNFTMarketplace.deploy();
        await hardhatNFTMarketplace.deployed();

        items = await ethers.getSigners();
        const HardhatNFT = await ethers.getContractFactory("NFT");
        hardhatNFT = await HardhatNFT.deploy();
        await hardhatNFT.deployed();

    });

    describe("addListing", function () {

        it("Should add a listing to the marketplace", async function () {
        
            // TODO: need to mock this so i can override the transfer approval 
            // set transfer approval on the NFT in the override
            const resp = await hardhatNFT.mint(
                TOKENID,
                CONTRACTADDRESS,
                ROYALTY
            )

            const itemId = resp.value;

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
            console.log(listing0)

        });

        it("Should add a listing to the marketplace", async function () {
        
            // TODO: need to mock this so i can override the transfer approval 
            // set transfer approval on the NFT in the override
            const resp = await hardhatNFT.mint(
                TOKENID,
                CONTRACTADDRESS,
                ROYALTY
            )

            const itemId = resp.value;

            await hardhatNFTMarketplace.addListing(
                itemId,
                SALEPRICE,
                STARTTIME,
                EXPIRATIONTIME
            );

            await hardhatNFTMarketplace.makeOffer(0);

            // verify isSold is false
            const listing0 = await hardhatNFTMarketplace.getListing(0);
            console.log(listing0)

            // assert(listing0[5], true);
            

        });

        // TODO: test the rest of functions
            
    });
});

const { expect } = require("chai");
const { ethers } = require("hardhat");

const TOKENID = 2390483209;
const CONTRACTADDRESS = "0xb8b44b60085E9eB2BAefAc59E191a66D8294dD49";
const ROYALTY = 10;
const ITEMID = 1;
const SALEPRICE = 20;
const STARTTIME = 1649362949
const EXPIRATIONTIME = 1680898949

describe("NFTMarketplace", function () {
    
    let marketplace;
    let hardhatNFT;
    let hardhatNFTMarketplace;

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
            const resp = await hardhatNFT.mint(
                TOKENID,
                CONTRACTADDRESS,
                ROYALTY
            )

            const itemId = resp.value;

            expect(await hardhatNFTMarketplace.addListing(
                itemId,
                SALEPRICE,
                STARTTIME,
                EXPIRATIONTIME
            ));

            // expect(await hardhatNFTMarketplace.getListing(0)).to.equal(1);

            // TODO: test if this function emits the right data

        });

        // TODO: test the rest of functions
            
    });
});

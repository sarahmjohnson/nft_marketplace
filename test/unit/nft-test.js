const { expect } = require("chai");
const { ethers } = require("hardhat");

const TOKENID = 2390483209;
const CONTRACTADDRESS = "0xb8b44b60085E9eB2BAefAc59E191a66D8294dD49";
const ROYALTY = 10;

describe("NFT", function () {
    
    let items;
    let hardhatNFT;

    beforeEach(async function () {

        items = await ethers.getSigners();
        const HardhatNFT = await ethers.getContractFactory("NFT");
        hardhatNFT = await HardhatNFT.deploy();
        await hardhatNFT.deployed();

    });

    describe("Mint", function () {

        it("Should mint an NFT", async function () {

            const resp = await hardhatNFT.mint(
                TOKENID,
                CONTRACTADDRESS,
                ROYALTY
            )

            const itemId = resp.value;
            
            // Validate tokenId is correct
            expect(await hardhatNFT.getTokenId(itemId)).to.equal(TOKENID);

            // Validate one item was minted and added to items
            expect(await hardhatNFT.getLengthItems()).to.equal(1);

        });
    });
});

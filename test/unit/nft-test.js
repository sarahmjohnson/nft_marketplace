const { expect } = require("chai");
const { ethers } = require("hardhat");

const TOKENURI = "https://easyupload.io/z0bw53";
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
                TOKENURI,
                ROYALTY
            )

            const tokenID = resp.value;
            console.log("tokenID: ", tokenID);
            
            // Validate one item was minted and added to items
            expect(await hardhatNFT.getLengthItems()).to.equal(1);

        });
    });
});

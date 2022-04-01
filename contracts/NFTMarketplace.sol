//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/* List NFTs with a sale price and expiration time.
- assume that its already minted

- list NFT on our marketplace
- needs to be approved to use for our contract

Users can buy NFTs using a newly deployed project ERC20 token -- check with gerald
- make offer
- buy

Royalties should be configurable for NFT sellers. e.g. take 10% of each sale, increase to 20%
- only if you are the original creator

Unit tests written for the contracts
Deployment script written and contracts deployed to a testnet.
Write an interface and then tweak the contract to consume the interface. 

nft_marketplace = [
    [0, "sarahsnft", $50, 2648850587, 10%], 
    [1, "davidsnft", $30, 1340958344, 20%],
    [2, "geraldsnft", $10, 9438509449, 15%]
]

1. approval
2. list nft on marketplace (set price and expiration time)
3. get function to return marketplace
*/

contract NFTMarketplace {

    ERC721 public NFT;
    uint256 public salePrice;
    uint256 public expirationTime;
    uint256 public tokenId;
    address public owner;


    struct NFTs {
        ERC721 NFT;
        uint256 salePrice;
        uint256 expirationTime;
    }

    NFTs[] private nfts;

    function checkApproval(ERC721 _NFT) public returns (address) {
        // Check approval for use with this contract
        owner = _NFT.ownerOf(tokenId);
        return owner;
    }

    function addNFT(ERC721 _NFT, uint256 _salePrice, uint256 _expirationTime) public {

        // List NFT on marketplace
        nfts.push(NFTs(_NFT, _salePrice, _expirationTime));
    }

    function getNFTMarketplace() public view returns (NFTs[] memory) {
        return nfts;
    }

    function makeOffer() public {}

    function buyNFT() public {}

    function configureRoyalty() public {}

}

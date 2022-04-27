//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract NFT is ERC721{

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address public marketplace;

    struct Item {
        uint256 royalty; // TODO: royalty amount set in NFT.sol is not currently factored in because openZep doesn't allow for changes to royalty
    }

    constructor () ERC721("UnionNFT", "UNFT") {}

    event NFTMinted(uint256 tokenId, uint256 royalty);
    event MarketplaceSet(address marketplace);
    event ApprovalSet(uint256 tokenId);


    modifier isItemOwner(uint256 tokenId){
        require(ERC721.ownerOf(tokenId) == msg.sender, "Sender does not own the item. Cannot set the marketplace.");
        _;
    }

    // Set marketplace equal to the address of the NFTMarketplace contract
    function setMarketplace(uint256 tokenId, address market) isItemOwner(tokenId) public {
        
        require(marketplace == address(0)); // already set
        
        marketplace = market;

        emit MarketplaceSet(marketplace);

    }
    
    // Approve NFT for listing on the NFT Marketplace
    function approveForListing(uint256 tokenId) external {

        // Approve token for listing on marketplace
        approve(marketplace, tokenId);

        emit ApprovalSet(tokenId);

    }

    // Mint an NFT and add to items. Returns itemId
    function mint(
        uint256 _royalty
    ) external {

        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        _safeMint(msg.sender, newTokenId);

        emit NFTMinted(newTokenId, _royalty);

    }

}
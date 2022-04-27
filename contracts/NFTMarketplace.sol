//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import "./NFT.sol";

contract NFTMarketplace {

    using Counters for Counters.Counter;
    Counters.Counter private _listingIds;
    NFT public nft;

    struct Listing {
        uint256 listingId; // ID for this listing in the marketplace
        uint256 tokenId; // ID for this NFT - created in NFT.sol
        address payable seller;
        uint256 salePrice;
        uint256 startTime;
        uint256 expirationTime;
        bool isSold;
    }

    Listing[] private marketplaceListings;

    event itemListed(uint256 listingId, uint256 tokenId, address seller, uint256 salePrice, uint256 startTime, uint256 expirationTime, bool isSold);
    event itemSold(uint256 listingId, address buyer, uint256 salePrice);

    constructor(NFT _nft) {
        nft = _nft;
    }

    modifier hasTransferApproval(uint256 tokenId){
        require(nft.getApproved(tokenId) == address(this), "Not approved for transfer. Cannot list on marketplace.");
        _;
    }

    modifier isItemOwner(uint256 tokenId){
        require(nft.ownerOf(tokenId) == msg.sender, "Sender does not own the item. Cannot list on marketplace.");
        _;
    }

    modifier itemExists(uint256 listingId){
        require(listingId < marketplaceListings.length && marketplaceListings[listingId].listingId == listingId, "Could not find listing.");
        _;
    }

    modifier isForSale(uint256 listingId){
        require(!marketplaceListings[listingId].isSold, "NFT is already sold.");
        _;
    }

    // Add a listing to the marketplace
    function addListing(
        uint256 _tokenId,
        uint256 _salePrice,
        uint256 _startTime,
        uint256 _expirationTime
    ) hasTransferApproval(_tokenId) isItemOwner(_tokenId) external virtual {
        // Check item has transfer approval and that sender is the owner of the token

        uint256 newListingId = _listingIds.current();
        bool isSold = false;
        address payable seller = payable(msg.sender);

        // List NFT on marketplace
        marketplaceListings.push(Listing(newListingId, _tokenId, seller, _salePrice, _startTime, _expirationTime, isSold));
    
        emit itemListed(newListingId, _tokenId, seller, _salePrice, _startTime, _expirationTime, isSold);

        _listingIds.increment();

    }

    // Return the length of the NFT marketplace - allows frontend to enumerate listings
    function getLengthMarketplace() external view returns (uint256 length) {
        return marketplaceListings.length;
    }

    // Return an NFT Listing at a given index
    function getListing(uint256 index) external view returns (Listing memory) {
        return marketplaceListings[index];
    }

    // Make an offer on a listing. Transfers ownership if approved for sale.
    function makeOffer(uint256 listingId) itemExists(listingId) isForSale(listingId) external payable {
        // Check item exists and is for sale

        // Check if funds match the listing price
        require(msg.value >= marketplaceListings[listingId].salePrice, "Offer rejected. Not enough funds sent.");

        uint256 tokenId = marketplaceListings[listingId].tokenId;

        address payable seller = marketplaceListings[listingId].seller;

        // Transfer token
        nft.safeTransferFrom(seller, msg.sender, tokenId);
        seller.transfer(msg.value);

        // Set to sold
        marketplaceListings[listingId].isSold = true;

        emit itemSold(listingId, msg.sender, marketplaceListings[listingId].salePrice);
    }

}
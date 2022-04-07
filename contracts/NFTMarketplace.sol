//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "./NFT.sol";

// TODO: change start and expiration times to timestamps

contract NFTMarketplace {
    using Counters for Counters.Counter;

    Counters.Counter private _listingIds;
    NFT public nft;

    struct Listing {
        uint256 listingId; // ID for this listing in the marketplace
        uint256 itemId; // ID for this NFT - created in NFT.sol
        uint256 salePrice;
        uint256 startTime;
        uint256 expirationTime;
        bool isSold;
    }

    Listing[] private marketplace;

    event itemListed(uint256 listingId, uint256 itemId, uint256 salePrice, uint256 startTime, uint256 expirationTime, bool isSold);
    event itemSold(uint256 listingId, address buyer, uint256 salePrice);

    modifier hasTransferApproval(uint256 itemId){
        require(nft.getApproved(nft.getTokenId(itemId)) == address(this), "Not approved for transfer. Cannot list on marketplace.");
        _;
    }

    modifier isItemOwner(uint256 itemId){
        require(nft.ownerOf(nft.getTokenId(itemId)) == msg.sender, "Sender does not own the item. Cannot list on marketplace.");
        _;
    }

    modifier itemExists(uint256 listingId){
        require(listingId < marketplace.length && marketplace[listingId].listingId == listingId, "Could not find listing.");
        _;
    }

    modifier isForSale(uint256 listingId){
        require(!marketplace[listingId].isSold, "NFT is already sold.");
        _;
    }

    // Add a listing to the marketplace
    function addListing(
        uint256 _itemId,
        uint256 _salePrice,
        uint256 _startTime,
        uint256 _expirationTime
    ) hasTransferApproval(_itemId) isItemOwner(_itemId) external {

        // Check item has transfer approval and that sender is the owner of the token

        _listingIds.increment();
        uint256 newListingId = _listingIds.current();

        bool isSold = false;

        // List NFT on marketplace
        marketplace.push(Listing(newListingId, _itemId, _salePrice, _startTime, _expirationTime, isSold));
    
        emit itemListed(newListingId, _itemId, _salePrice, _startTime, _expirationTime, isSold);

    }

    // Return the length of the NFT marketplace - allows frontend to enumerate listings
    function getLengthMarketplace() external virtual view returns (uint256 length) {
        return marketplace.length;
    }

    // Return an NFT Listing at a given index
    function getListing(uint256 index) external view returns (Listing memory) {
        return marketplace[index];
    }

    // Make an offer on a listing. Transfers ownership if approved for sale.
    function makeOffer(uint256 listingId) itemExists(listingId) isForSale(listingId) payable external {
        // Check item exists and is for sale

        // Check if funds match the listing price
        require(msg.value >= marketplace[listingId].salePrice, "Offer rejected. Not enough funds sent.");

        uint256 itemId = marketplace[listingId].itemId;
        address payable owner = nft.getOwner(itemId);
        uint256 tokenId = nft.getTokenId(itemId);

        // Transfer token
        nft.safeTransferFrom(owner, msg.sender, tokenId);

        // Set to sold
        marketplace[listingId].isSold = true;

        owner.transfer(msg.value);
        emit itemSold(listingId, msg.sender, marketplace[listingId].salePrice);
    }

}
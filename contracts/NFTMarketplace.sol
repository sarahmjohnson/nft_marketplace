//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// question: should we remove from marketplace after sold, or keep?

// question: should any owner of an NFT be able to change the royalty or just the orginal owner (creator)


contract NFTMarketplace {
    using Counters for Counters.Counter;

    Counters.Counter private _listingIds;

    ERC721 private NFT;
    ERC2981 private NFTRoyalty1; // fixme
    ERC721Royalty private NFTRoyalty;
    address private ownerAddress;
    uint256 private royaltyInTokens;

    struct Listing {
        uint256 listingId; // ID for this listing in the marketplace
        uint256 tokenId; // NFT token ID
        address contractAddress; // NFT address
        address payable owner; // Address who listed this NFT in the marketplace
        uint256 salePrice;
        uint256 startTime;
        uint256 expirationTime;
        uint256 royalty; // question: should we include this in the listing?
        bool isSold;
    }

    Listing[] private marketplace;

    event itemListed(uint256 listingId, uint256 tokenId, uint256 salePrice);
    event itemSold(uint256 listingId, address buyer, uint256 salePrice);

    modifier hasTransferApproval(uint256 tokenId){
        require(NFT.getApproved(tokenId) == address(this), "Not approved for transfer. Cannot list on marketplace.");
        _;
    }

    modifier isItemOwner(uint256 tokenId){
        require(NFT.ownerOf(tokenId) == msg.sender, "Sender does not own the item. Cannot list on marketplace.");
        _;
    }

    modifier itemExists(uint256 id){
        require(id < marketplace.length && marketplace[id].listingId == id, "Could not find listing.");
        _;
    }

    modifier isForSale(uint256 id){
        require(!marketplace[id].isSold, "NFT is already sold.");
        _;
    }

    function getRoyalty(
        uint256 _tokenId, 
        uint256 _salePrice
    ) public returns (uint256 royalty) {
        
        (ownerAddress, royaltyInTokens) = NFTRoyalty.royaltyInfo(_tokenId, _salePrice);

        // Royalty is returned in tokens, so we convert to percentage
        uint256 royaltyAsPercentage = royaltyInTokens / _salePrice * 100;

        return royaltyAsPercentage;
    }

    // Add a listing to the marketplace
    function addListing(
        uint256 _tokenId,
        address _contractAddress,
        uint256 _salePrice,
        uint256 _startTime,
        uint256 _expirationTime
    ) hasTransferApproval(_tokenId) isItemOwner(_tokenId) public {
        // Check item has transfer approval and that sender is the owner of the token

        _listingIds.increment();
        uint256 newListingId = _listingIds.current();

        uint256 royalty = getRoyalty(_tokenId, _salePrice);
        bool isSold = false;
        address payable owner = payable(msg.sender);

        // question: should i set the start and expiration or should the lister?

        // List NFT on marketplace
        marketplace.push(Listing(newListingId, _tokenId, _contractAddress, owner, _salePrice, _startTime, _expirationTime, royalty, isSold));
    
        emit itemListed(newListingId, _tokenId, _salePrice);

    }

    // Return an NFT Listing at a given index
    function getListing(uint256 index) public view returns (Listing memory) {
        return marketplace[index];
    }

    // Return the length of the NFT marketplace - allows frontend to enumerate listings
    function getLengthMarketplace() public virtual view returns (uint256 length) {
        return marketplace.length;
    }

    // Make an offer on a listing. Transfers ownership if approved for sale.
    function makeOffer(uint256 listingId) itemExists(listingId) isForSale(listingId) payable external {
        // Check item exists and is for sale

        // Check if funds match the listing price
        require(msg.value >= marketplace[listingId].salePrice, "Offer rejected. Not enough funds sent.");

        // Set to sold
        marketplace[listingId].isSold = true;

        // Transfer token
        NFT.safeTransferFrom(marketplace[listingId].owner, msg.sender, marketplace[listingId].tokenId);

        marketplace[listingId].owner.transfer(msg.value);
        emit itemSold(listingId, msg.sender, marketplace[listingId].salePrice);
    }

    // Change royalty
    function configureRoyalty(uint256 _listingId, uint256 _updatedRoyalty) public {
        // Check to make sure only creator can configure royalty

        uint256 tokenId = marketplace[_listingId].tokenId;

        // Denominator defaults to 10000, so multipy _updatedRoyalty by 100 to get correct percentage
        // This doesn't work yet. Having trouble because calling an internal function.
        // _setTokenRoyalty(tokenId, msg.sender, _updatedRoyalty * 100);
    }

}
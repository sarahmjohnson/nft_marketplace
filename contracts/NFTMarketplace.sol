//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFTMarketplace {
    using Counters for Counters.Counter;

    Counters.Counter private _listingIds;

    address public owner;
    uint256 public royaltyInTokens;
    ERC721 private NFT;
    ERC721Royalty private NFTRoyalty;

    struct Listing {
        uint256 listingId; // ID for this listing in the marketplace
        uint256 tokenId; // NFT token ID
        address contractAddress; // NFT address
        address payable sender; // Address who listed this NFT in the marketplace
        uint256 salePrice;
        uint256 startTime;
        uint256 expirationTime;
        uint256 royalty;
        bool isSold;
    }

    Listing[] private marketplace;

    modifier hasTransferApproval(uint256 tokenId){
        require(NFT.getApproved(tokenId) == address(this), "Not approved for transfer. Cannot list on marketplace.");
        _;
    }

    modifier isItemOwner(uint256 tokenId){
        require(NFT.ownerOf(tokenId) == msg.sender, "Sender does not own the item. Cannot list on marketplace.");
        _;
    }

    modifier itemExists(uint256 id){
        require(id < marketplace.length && marketplace[id].listingId == id, "Could not find item");
        _;
    }

    modifier isForSale(uint256 id){
        require(!marketplace[id].isSold, "Item is already sold");
        _;
    }

    function getRoyalty(uint256 _tokenId, uint256 _salePrice) public returns (uint256 royalty) {
        
        (owner, royaltyInTokens) = NFTRoyalty.royaltyInfo(_tokenId, _salePrice);

        // Royalty is returned in tokens, so we convert to percentage
        uint256 royaltyAsPercentage = royaltyInTokens / _salePrice * 100;
        
        return royaltyAsPercentage;
    }

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
        address payable sender = payable(msg.sender);

        // List NFT on marketplace
        marketplace.push(Listing(newListingId, _tokenId, _contractAddress, sender, _salePrice, _startTime, _expirationTime, royalty, isSold));
    }

    // Return an NFT Listing at a given index
    function getListing(uint256 index) public view returns (Listing memory) {
        return marketplace[index];
    }

    // Return the length of the NFT marketplace - allows frontend to enumerate listings
    function getLengthMarketplace() public view returns (uint256 length) {
        return marketplace.length;
    }

    function makeOffer(uint256 listingId) itemExists(listingId) isForSale(listingId) public {
        // Check item exists and is for sale

        // check if funds match the listing price
        // calls buyNFT if the offer matches the buy criteria
    }

    function buyNFT() public {
        // remove from marketplace
        // safeTransferFrom
    }

    // question: should we remove from marketplace after sold, or keep?

    function configureRoyalty() public {
        // check to make sure only creator can configure royalty
        // set default royalty function
    }

}
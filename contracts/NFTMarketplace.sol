//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFTMarketplace {
    using Counters for Counters.Counter;

    Counters.Counter private _listingIds;

    address public owner;
    uint256 public royalty;

    struct Listing {
        uint256 listingId; // ID for this listing in the marketplace
        uint256 tokenId; // NFT token ID
        address contractAddress; // NFT address
        uint256 salePrice;
        uint256 startTime;
        uint256 expirationTime;
        uint256 royalty;
    }

    Listing[] private listing;

    // function checkApproval(ERC721 _NFT) public returns (address) {
        // Check approval for use with this contract
        // This doesn't work yet
        // NFTAddress = _NFT.address()
    //     owner = _NFT.ownerOf(tokenId);
    //     return owner;
    // }

    function getRoyalty(address _contractAddress) public returns (uint256 royalty) {
        // royaltyInfo(_tokenId, _salePrice)
        return royalty;
    }

    function addListing(
        uint256 _tokenId,
        address _contractAddress,
        uint256 _salePrice,
        uint256 _startTime,
        uint256 _expirationTime
    ) public {
        // First, check approval

        _listingIds.increment();
        uint256 newListingId = _listingIds.current();

        royalty = getRoyalty(_contractAddress);

        // List NFT on marketplace
        listing.push(Listing(newListingId, _tokenId, _contractAddress, _salePrice, _startTime, _expirationTime, royalty));
    }

    // Return an NFT Listing at a given index
    function getListing(uint256 index) public view returns (Listing memory) {
        return listing[index];
    }

    // Return the length of the NFT marketplace - allows frontend to enumerate listings
    function getLengthMarketplace() public view returns (uint256 length) {
        return listing.length;
    }

    function makeOffer() public {}

    function buyNFT() public {}

    function configureRoyalty() public {}

}

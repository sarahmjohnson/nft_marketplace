//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "../NFTMarketplace.sol";
import "../NFT.sol";

contract NFTMarketplaceMock {
    // using Counters for Counters.Counter;

    // Counters.Counter private _listingIds;
    // Listing[] private marketplace;

    // constructor(NFT _nft) {
    //     nft = _nft;
    // }

    // // Add a listing to the marketplace
    // function addListing(
    //     uint256 _itemId,
    //     uint256 _salePrice,
    //     uint256 _startTime,
    //     uint256 _expirationTime
    // ) external override virtual {

    //     // Check item has transfer approval and that sender is the owner of the token

    //     uint256 newListingId = _listingIds.current();

    //     bool isSold = false;

    //     // List NFT on marketplace
    //     marketplace.push(Listing(newListingId, _itemId, _salePrice, _startTime, _expirationTime, isSold));
    
    //     emit itemListed(newListingId, _itemId, _salePrice, _startTime, _expirationTime, isSold);

    //     _listingIds.increment();

    // }

}
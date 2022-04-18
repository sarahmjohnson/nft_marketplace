 //SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "../NFTMarketplace.sol";

contract NFTMarketplaceMock is NFTMarketplace {

    using Counters for Counters.Counter;

    Counters.Counter private _listingIds;
    Listing[] private marketplace;


     // Add a listing to the marketplace
    function addListing(
        uint256 _itemId,
        uint256 _salePrice,
        uint256 _startTime,
        uint256 _expirationTime
    ) external override {

        // Check item has transfer approval and that sender is the owner of the token

        _listingIds.increment();
        uint256 newListingId = _listingIds.current();

        bool isSold = false;

        // List NFT on marketplace
        marketplace.push(Listing(newListingId, _itemId, _salePrice, _startTime, _expirationTime, isSold));
    
        emit itemListed(newListingId, _itemId, _salePrice, _startTime, _expirationTime, isSold);

    }

}
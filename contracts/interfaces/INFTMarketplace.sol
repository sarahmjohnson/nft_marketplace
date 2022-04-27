// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface INFTMarketplace {
  
  function addListing(
    uint256 _tokenId,
    uint256 _salePrice,
    uint256 _startTime,
    uint256 _expirationTime
  ) external;
  
  function getLengthMarketplace() external;

  function getListing(uint256 index) external;
  
  function makeOffer(uint256 _listingId) external;
}
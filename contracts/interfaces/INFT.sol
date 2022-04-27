// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface INFT {
  
  function mint(
    string memory _tokenURI,
    uint256 _royalty
  ) external;

  function approveForListing(
    uint256 tokenId
  ) external;

  function setMarketplace(
    uint256 tokenId,
    address market
  ) external;
  
}
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

interface INFTMarketplace {
  
  function addNFT(ERC721 _NFT, uint256 _salePrice, uint256 _expirationTime) external;
  
  function getNFTMarketplace() external;
  
  function makeOffer() external;
  
  function configureRoyalty() external;
}
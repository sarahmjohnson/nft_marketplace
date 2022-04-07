// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface INFT {
  
  function mint(
    uint256 _tokenId,
    address _contractAddress,
    uint256 _royalty
  ) external;
  
}
//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "../NFT.sol";

contract NFTMock is NFT {

    using Counters for Counters.Counter;

    Counters.Counter private _itemIds;    // Mint an NFT and add to items. Returns itemId
    Item[] private items;

    function mint(
        uint256 _tokenId,
        address _contractAddress,
        uint256 _royalty
    ) external override returns (uint256) {
        

        _itemIds.increment();
        uint256 newItemId = _itemIds.current();

        _safeMint(msg.sender, newItemId);
        // approve(marketplace, newItemId);
        // question: how do i set the approval to our marketplace

        address creator = msg.sender;
        address payable owner = payable(msg.sender);

        approve(msg.sender, _tokenId);

        // Add NFT to items
        items.push(Item(newItemId, _tokenId, _contractAddress, creator, owner, _royalty));
    
        emit itemCreated(newItemId, _tokenId, _contractAddress, creator, owner, _royalty);

        return newItemId;
    }

}
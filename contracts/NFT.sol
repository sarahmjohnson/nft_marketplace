//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT is ERC721{

    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    mapping(uint256=>bool) MintedNFTs;

    struct Item {
        uint256 itemId; // ID for this item
        uint256 tokenId; // NFT token ID
        address contractAddress; // NFT address
        address creator; // Address who is the original creator of the NFT
        address payable owner; // Address who currently owns the NFT
        uint256 royalty;
    }

    Item[] private items;

    constructor () ERC721("UnionNFT", "UNFT") {}

    event itemCreated(uint256 itemId, uint256 tokenId, address contractAddress, address creator, address owner, uint256 royalty);

    // Mint an NFT and add to items. Returns itemId
    function mint(
        uint256 _tokenId,
        address _contractAddress,
        uint256 _royalty
    ) external virtual returns (uint256) {

        require(!MintedNFTs[_tokenId],"This NFT is already minted and listed in the marketplace.");

        _itemIds.increment();
        uint256 newItemId = _itemIds.current();

        _safeMint(msg.sender, newItemId);
        // TODO: how do i get the deployed contract address here?
        // approve(token.address, newItemId);

        address creator = msg.sender;
        address payable owner = payable(msg.sender);

        // Add NFT to items
        items.push(Item(newItemId, _tokenId, _contractAddress, creator, owner, _royalty));
        
        // Add tokenId to previously MintedNFTs
        MintedNFTs[_tokenId] = true;
        
        emit itemCreated(newItemId, _tokenId, _contractAddress, creator, owner, _royalty);

        return newItemId;
    }

    // question: is this the best way to access variables from NFTMarketplace?
    function getTokenId(uint256 itemId) external view returns (uint256) {
        return items[itemId].tokenId;
    }

    function getOwner(uint256 itemId) public view returns (address payable) {
        return items[itemId].owner;
    }

    function getLengthItems() public view returns (uint256) {
        return items.length;
    }

}
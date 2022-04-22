//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT is ERC721{

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address public marketplace;
    mapping(uint256=>bool) MintedNFTs;

    struct Item {
        uint256 tokenId; // NFT ID
        string tokenURI; // NFT URI
        uint256 royalty; // TODO: royalty amount set in NFT.sol is not currently factored in
    }

    Item[] private items;

    constructor () ERC721("UnionNFT", "UNFT") {}

    event itemCreated(uint256 tokenId, string tokenURI, uint256 royalty);

    // Set marketplace equal to the address of the NFTMarketplace contract
    function setMarketplace(address market) public returns (address) {
        marketplace = market;
        return marketplace;
    }

    // Mint an NFT and add to items. Returns itemId
    function mint(
        string memory _tokenURI,
        uint256 _royalty
    ) external virtual returns (uint256) {

        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        require(!MintedNFTs[newTokenId],"This NFT is already minted.");

        _safeMint(msg.sender, newTokenId);

        // Approve token for listing on marketplace
        approve(marketplace, newTokenId);

        // Add NFT to items
        items.push(Item(newTokenId, _tokenURI, _royalty));
        
        // Add tokenId to previously MintedNFTs
        MintedNFTs[newTokenId] = true;
        
        emit itemCreated(newTokenId, _tokenURI, _royalty);

        return newTokenId;
    }

    function getLengthItems() public view returns (uint256) {
        return items.length;
    }

}
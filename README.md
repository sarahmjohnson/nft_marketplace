# NFT Listing Market

This project provides an NFT Listing Marketplace contract.

It allows for minting NFTs and then listing them on the marketplace. Offers can then be made on the listings, and if the conditions are met, a sale with go through.

```NFT```
mint
 ```shell
royalty = 10

mint(royalty)

* emits tokenId
 ```
 
 ```shell
// Set marketplace equal to the address of the NFTMarketplace contract

marketplaceAddress = "0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9"
tokenId = 1

setMarketplace(
    marketplaceAddress,
    tokenId
)
```

approveForListing
 ```shell
// Approve NFT for listing on the NFT Marketplace

tokenId = 1

approveForListing(
    tokenId
)
```

addListing
 ```shell
// Add a listing to the marketplace

tokenId = 1
salePrice = ethers.utils.parseEther(".0000001")
startTime = 1649362949
expirationTime = 1949362949

addListing(
    tokenId,
    salePrice,
    startTime,
    expirationTime
)

* emits listingId
```

 makeOffer
```shell
// Make an offer on a listing. Transfers ownership if approved for sale.

listingId = 1

makeOffer(
    listingId,
    {value: ethers.utils.parseEther(".0000001")}
)
 ```

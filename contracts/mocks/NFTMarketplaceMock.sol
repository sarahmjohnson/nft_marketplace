//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "../NFTMarketplace.sol";

contract NFTMarketplaceMock is NFTMarketplace {

    function getLengthMarketplace() public override view returns (uint256 length) {
        return 5;
    }

}
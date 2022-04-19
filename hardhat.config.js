require("@nomiclabs/hardhat-waffle");
require('@openzeppelin/hardhat-upgrades');
let secret = require("./secret.json");

module.exports = {
  solidity: "0.8.4",
  networks: {
    kovan: {
      url: secret.url,
      accounts: [secret.key]
    }
  }
};

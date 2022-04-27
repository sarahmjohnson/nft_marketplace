require("@nomiclabs/hardhat-waffle");
require('@openzeppelin/hardhat-upgrades');
// require("@nomiclabs/hardhat-truffle5");
let secret = require("./secret.json");

module.exports = {
  solidity: "0.8.4",
  networks: {
    kovan: {
      url: secret.url,
      accounts: [secret.key]
    },
    rinkeby: {
      url: secret.url1,
      accounts: [secret.key1]
    },
  }
};

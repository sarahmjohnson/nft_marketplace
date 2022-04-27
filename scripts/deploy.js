async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const Token0 = await ethers.getContractFactory("NFT");
  const token0 = await Token0.deploy();

  const Token1 = await ethers.getContractFactory("NFTMarketplace");
  const token1 = await Token1.deploy(token0.address);

  console.log("Token address:", token1.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
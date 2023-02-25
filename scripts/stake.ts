import { ethers } from "hardhat";

async function main() {
    const [owner] = await ethers.getSigners();
  
  const Token = await ethers.getContractFactory("Nftstake");
  const contract = await Token.deploy();
  await contract.deployed();
  console.log(`contract deployed at ${contract.address}`)

  const batholder = "0xe3444499a350cAF049f32781a29adB3B65A1E7ca";

  const erc20 = await ethers.getContractAt(IERC20, "0x0D8775F648430679A709E98d2b0Cb6250d2887EF")



}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

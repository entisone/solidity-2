// scripts/deploy.ts

import { ethers } from "hardhat";

async function main() {
  const CatRace = await ethers.getContractFactory("CatRace");
  const catRace = await CatRace.deploy();

  await catRace.waitForDeployment();

  console.log(`CatRace deployed to: ${await catRace.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

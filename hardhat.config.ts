import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.28",
  typechain: {
    outDir: "typechain-types",  // Specifica la cartella di destinazione per i tipi
    target: "ethers-v5",        // Usa TypeChain con ethers v5
  },
};

export default config;

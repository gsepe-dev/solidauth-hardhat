# SolidAuth - Hardhat Project

This project contains the **SolidAuth** smart contract, developed using Hardhat. It includes the contract source code, tests, and deployment scripts.

## Setup

Before running any commands, install the dependencies:

```shell
npm install --save-dev hardhat
npm i typechain
npm install --save ethers
npm i @typechain/ethers-v5
npm install --save-dev @nomiclabs/hardhat-ethers
```

## Compile & Run Tests

```shell
npx hardhat compile
npx hardhat typechain
npx hardhat test
```
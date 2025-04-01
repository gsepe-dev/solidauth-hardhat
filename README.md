# SolidAuth - Hardhat Project

This project contains the **SolidAuth** smart contract, developed using Hardhat. It includes the contract source code, tests, and deployment scripts.

## Setup

Before running any commands, clean the dependencies:

```shell
npm cache clean --force
rm -rf node_modules package-lock.json
```

Then install the correct dependencies:

```shell
npm install hardhat@2.17.1 --save-dev
npm install ethers@5.7.2 --save-dev
npm install ts-node typescript @types/node --save-dev
npm install @nomicfoundation/hardhat-toolbox@2
```

## Compile & Run Tests

```shell
npx hardhat compile
npx hardhat typechain
npx hardhat test
```
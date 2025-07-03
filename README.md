# SolidAuth

This project contains the **SolidAuth** smart contract, developed using Hardhat.

It includes the contract source code, tests, and deployment scripts.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

See deployment for notes on how to deploy the project on a live system.

### Prerequisites

Before running any commands, clean the dependencies:

```shell
npm cache clean --force
rm -rf node_modules package-lock.json
```

### Installing

Then install the correct dependencies:

```shell
npm install hardhat@2.17.1 --save-dev
npm install ethers@5.7.2 --save-dev
npm install ts-node typescript @types/node --save-dev
npm install @nomicfoundation/hardhat-toolbox@2
```

## Running the tests

```shell
npx hardhat compile
npx hardhat typechain
npx hardhat test
```

## Built With

* [Hardhat](https://hardhat.org/) - Ethereum development environment
* [npm](https://www.npmjs.com/) - Tool for installing and managing JavaScript modules and packages for Node.js applications

## License

This project is licensed under the MIT License

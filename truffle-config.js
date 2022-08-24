//jshint esversion:8
const path = require('path');
const HDWalletProvider = require('@truffle/hdwallet-provider');
require('dotenv').config();
const mnemonic = process.env.MNEMONIC;
const url = process.env.ALCHEMY_POLYGON_MUMBAI_RPC_URL;

module.exports = {
  contracts_build_directory: path.join(__dirname, 'abis'),
  contracts_directory: path.join(__dirname, 'contracts'),
  migrations_directory: path.join(__dirname, 'migrations'),
  networks: {
    development: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*',
    },
    matic: {
      provider: () => {
        return new HDWalletProvider(mnemonic, url);
      },
      network_id: '80001',
    },
    binance: {
      provider: () =>
        new HDWalletProvider(
          mnemonic,
          'https://data-seed-prebsc-1-s1.binance.org:8545'
        ),
      network_id: 97,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true,
    },
  },
  compilers: {
    solc: {
      version: '0.8.4',
      optimizer: {
        enabled: true,
        runs: 600,
      },
    },
  },
};

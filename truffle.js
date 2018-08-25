const HDWalletProvider = require("truffle-hdwallet-provider");


/*
 * NB: since truffle-hdwallet-provider 0.0.5 you must wrap HDWallet providers in a
 * function when declaring them. Failure to do so will cause commands to hang. ex:
 * ```
 * mainnet: {
 *     provider: function() {
 *       return new HDWalletProvider(mnemonic, 'https://mainnet.infura.io/<infura-key>')
 *     },
 *     network_id: '1',
 *     gas: 4500000,
 *     gasPrice: 10000000000,
 *   },
 */

// send ether to this address: 0x627306090abab3a6e1400e9345bc60c78a8bef57
const mnemonic = "candy maple cake sugar pudding cream honey rich smooth crumble sweet treat"


module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    kovan: {
      provider: () => new HDWalletProvider(mnemonic, "https://kovan.infura.io/TOKEN"),
      gas: 4700000,
      network_id: 42
    }
  }
};

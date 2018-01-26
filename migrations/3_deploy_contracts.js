const path = require('path');
const address = require(path.resolve( __dirname, "../private.js" )).ADDRESS;

//Commented out some of the code so that i can add the rest of the contract later for testing.
// const DTCrowdsale = artifacts.require("./DTCrowdsale.sol");
// const DTPresale = artifacts.require("./DTPresale.sol");
const DTToken = artifacts.require("./DreamTeamToken.sol");
const MigrationAgent = artifacts.require("./MigrationAgent.sol");
const MultiSigWalletWithDailyLimit = artifacts.require("./MultiSigWalletWithDailyLimit.sol");
const DTMigrationToken = artifacts.require("./DreamTeamMigrationToken.sol");

module.exports = function(deployer) {
  let startTimePresale, startTimeCrowdsale; // blockchain block number (in timestamp) where the crowdsale will commence.
  let endTimePresale, endTimeCrowdsale;  // blockchain block number (in timestamp) where it will end.
  let foundationWallet, migrationMaster; // the address that will hold the fund. Recommended to use a multisig one for security.

  const rate = new web3.BigNumber(1000) // rate of ether to DT Coin in ether: 1000 dtt are 1 ether

  //crowdsale sattings
  const goal = new web3.BigNumber(2000000000000000000) // soft cap
  const cap = new web3.BigNumber(8000000000000000000) // hard cap (in wei)
  const minInvest = new web3.BigNumber(1000000000000000000) // minimum investment (in wei)
  const maxCumulativeInvest = new web3.BigNumber(3000000000000000000) // max cumulative investment (in weo)

  //presale settings
  const presalecap = new web3.BigNumber(8000000000000000000) // hard cap (in wei)
  const distributionCap = new web3.BigNumber(8000000000000000000000) // max amount of tokens (in atto) to be sold manually distributed

  //common settings
  const maxGasPrice = new web3.BigNumber(5000000000000000000) // max amount og gas allowed per transaction 50 gwei
  const minBuyingRequestInterval = new web3.BigNumber(60) // frequency between one call and the next one for an address (in seconds)

  if (process.argv.toString().indexOf('ropsten') !== -1) {
    startTimePresale = Math.round(new Date().getTime()/1000) + 400; //current time plus 6.6 minutes
    endTimePresale = startTimePresale + 3600; //1 hour

    startTimeCrowdsale = endTimePresale + 1500; //10 min
    endTimeCrowdsale = startTimeCrowdsale + 3600; //1 hour

    migrationMaster = '0xE4765a92f06725DEFfDDde074E8FF150C25A28EC';

    console.log('Using ropsten network.');
  } else {
    startTimePresale = web3.eth.getBlock('latest').timestamp + 400;
    endTimePresale = startTimePresale + 3600; //1 hour

    startTimeCrowdsale = endTimePresale + 1500; //10 min
    endTimeCrowdsale = startTimeCrowdsale + 3600; //10 days

    wallet = web3.eth.accounts[0];
    migrationMaster = web3.eth.accounts[1];
    console.log('Using testrpc network.');
  }

  MultiSigWalletWithDailyLimit.deployed().then(function(multisig){
    console.log('MULTISIG WALLET IS: ', multisig.address);
    foundationWallet = multisig.address;
    deployer.deploy(DTPresale, startTimePresale, endTimePresale, rate, presalecap, distributionCap, maxGasPrice, minBuyingRequestInterval, foundationWallet);
    deployer.deploy(DTToken, migrationMaster);
  });

  // deployer.deploy(DTCrowdsale, startTimeCrowdsale, endTimeCrowdsale, rate, goal, cap, minInvest, maxCumulativeInvest, maxGasPrice, minBuyingRequestInterval, wallet);
};

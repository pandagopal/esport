module.exports = {
  port: 8555,
  norpc: true,
  testCommand: 'GEN_TESTS_TIMEOUT=400 GEN_TESTS_QTY=40 truffle test --network coverage test/DTCrowdsale.js test/DTPresale.js test/DTToken.js test/WhitelistedCrowdsale.js test/DTPresaleGenTest.js test/DTCrowdsaleGenTest.js',
  copyNodeModules: true,
  skipFiles: [
    'test-helpers/Message.sol',
    'Crowdsale.sol',
    'DTMigrationToken.sol',
    'MultiSigWalletWithDailyLimit.sol',
  ]
}

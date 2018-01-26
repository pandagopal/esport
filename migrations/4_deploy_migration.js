
const MigrationAgent = artifacts.require("./MigrationAgent.sol");
const DTToken = artifacts.require("./DreamTeamToken.sol");

module.exports = function(deployer) {
  DTToken.deployed().then(function(token){
    deployer.deploy(MigrationAgent, token.address);
  });
};

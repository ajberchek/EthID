var EthID = artifacts.require("./EthID.sol");

module.exports = function(deployer) {
  deployer.deploy(EthID);
};

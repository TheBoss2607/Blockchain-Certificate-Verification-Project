const EmployerRegistry = artifacts.require("EmployerRegistry");

module.exports = function(deployer) {
  deployer.deploy(EmployerRegistry);
}; 
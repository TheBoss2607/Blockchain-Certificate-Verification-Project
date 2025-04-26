const StudentRegistry = artifacts.require("StudentRegistry");
const InstitutionRegistry = artifacts.require("InstitutionRegistry");
const CertificateManager = artifacts.require("CertificateManager");
const ValidatorRegistry = artifacts.require("ValidatorRegistry");

module.exports = function(deployer) {
  deployer.deploy(StudentRegistry)
    .then(() => deployer.deploy(InstitutionRegistry))
    .then(() => deployer.deploy(CertificateManager))
    .then(() => deployer.deploy(ValidatorRegistry));
}; 
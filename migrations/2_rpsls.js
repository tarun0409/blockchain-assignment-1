const rpsls = artifacts.require("./Rpsls");

module.exports = function(deployer){
    deployer.deploy(rpsls, false, {value: 5});
}
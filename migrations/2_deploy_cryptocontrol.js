var CryptoControlToken = artifacts.require("CryptoControlToken");
var CryptoControlClaimReward = artifacts.require("CryptoControlClaimReward");


module.exports = function (deployer) {
    deployer.deploy(CryptoControlToken);
    deployer.deploy(CryptoControlClaimReward);
};

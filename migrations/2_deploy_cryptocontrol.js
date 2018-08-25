var CryptoControlToken = artifacts.require("CryptoControlToken");
var CryptoControlClaimReward = artifacts.require("CryptoControlClaimReward");


module.exports = function (deployer) {
    deployer.deploy(CryptoControlToken);
    deployer.deploy(CryptoControlClaimReward, '0x0f4f2ac550a1b4e2280d04c21cea7ebd822934b5');
};

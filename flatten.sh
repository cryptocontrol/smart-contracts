# pip3 install solidity-flattener

rm -rf out
mkdir out
solidity_flattener contracts/CryptoControlClaimReward.sol > out/CryptoControlClaimReward.sol
solidity_flattener contracts/CryptoControlToken.sol > out/CryptoControlToken.sol
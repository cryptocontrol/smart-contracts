# pip3 install solidity-flattener

rm -rf out
mkdir out
solidity_flattener contracts/CryptoControlClaimDividends.sol > out/CryptoControlClaimDividends.sol
solidity_flattener contracts/CryptoControlToken.sol > out/CryptoControlToken.sol
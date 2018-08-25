pragma solidity ^0.4.22;

import "openzeppelin-solidity/contracts/token/ERC20/RBACMintableToken.sol";


contract CryptoControlToken is RBACMintableToken {
    string public name = "CryptoControl";
    string public symbol = "CC";
    uint8 public decimals = 18;
}
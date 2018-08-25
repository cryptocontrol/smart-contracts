pragma solidity ^0.4.24;

import "./openzeppelin-solidity/token/ERC20/RBACMintableToken.sol";


contract CryptoControlToken is RBACMintableToken {
    string public name = "CryptoControl";
    string public symbol = "CC";
    uint8 public decimals = 18;
}
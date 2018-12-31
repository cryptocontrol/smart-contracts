pragma solidity ^0.4.24;

import "./openzeppelin-solidity/token/ERC20/BurnableToken.sol";
import "./openzeppelin-solidity/token/ERC20/PausableToken.sol";
import "./openzeppelin-solidity/token/ERC20/CappedToken.sol";


contract CryptoControlToken is BurnableToken, PausableToken, CappedToken {
    string public name = "CryptoControl";
    string public symbol = "CCIO";
    uint8 public decimals = 18;
    string public contactInformation = "contact@cryptocontrol.io";


    constructor () CappedToken(10000000000000000000) {}
}
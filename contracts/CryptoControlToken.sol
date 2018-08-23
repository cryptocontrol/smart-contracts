pragma solidity ^0.4.22;

import 'openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol';


contract CryptoControlToken is MintableToken {
  string public name = 'CryptoControl';
  string public symbol = 'CC';
  uint8 public decimals = 18;
}

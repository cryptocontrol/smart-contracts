pragma solidity ^0.4.24;

import "./openzeppelin-solidity/token/ERC20/MintableToken.sol";


contract TrueUSDMockToken is MintableToken {
    string public name = "TrueUSDMock";
    string public symbol = "TUSD";
    uint8 public decimals = 18;
}
pragma solidity ^0.5.1;

import "./openzeppelin-solidity/token/ERC20/MintableToken.sol";


contract TrueUSDMockToken is MintableToken {
    string public name = "TrueUSDMock";
    string public symbol = "TUSD";
    uint8 public decimals = 18;
}
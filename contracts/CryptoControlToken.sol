pragma solidity ^0.5.1;

import "./openzeppelin-solidity/token/ERC20/BurnableToken.sol";
import "./openzeppelin-solidity/token/ERC20/PausableToken.sol";
import "./openzeppelin-solidity/token/ERC20/CappedToken.sol";


contract CryptoControlToken is BurnableToken, PausableToken, CappedToken {
    address public upgradedAddress;
    bool public deprecated;
    string public contactInformation = "contact@cryptocontrol.io";
    string public name = "CryptoControl";
    string public reason;
    string public symbol = "CCIO";
    uint8 public decimals = 18;

    constructor () CappedToken(10000000000000000000) public {}

    // Fix for the ERC20 short address attack.
    modifier onlyPayloadSize(uint size) {
        require(!(msg.data.length < size + 4), "payload too big");
        _;
    }

    // Forward ERC20 methods to upgraded contract if this one is deprecated
    function transfer(address _to, uint _value) public whenNotPaused returns (bool) {
        if (deprecated) return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
        else return super.transfer(_to, _value);
    }

    // Forward ERC20 methods to upgraded contract if this one is deprecated
    function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns (bool) {
        if (deprecated) return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
        else return super.transferFrom(_from, _to, _value);
    }

    // Forward ERC20 methods to upgraded contract if this one is deprecated
    function balanceOf(address who) public view returns (uint256) {
        if (deprecated) return UpgradedStandardToken(upgradedAddress).balanceOf(who);
        else return super.balanceOf(who);
    }

    // Forward ERC20 methods to upgraded contract if this one is deprecated
    function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) returns (bool) {
        if (deprecated) return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
        else return super.approve(_spender, _value);
    }

    // Forward ERC20 methods to upgraded contract if this one is deprecated
    function allowance(address _owner, address _spender) public view returns (uint remaining) {
        if (deprecated) return StandardToken(upgradedAddress).allowance(_owner, _spender);
        else return super.allowance(_owner, _spender);
    }

    // deprecate current contract in favour of a new one
    function deprecate(address _upgradedAddress, string memory _reason) public onlyOwner {
        deprecated = true;
        upgradedAddress = _upgradedAddress;
        reason = _reason;
        emit Deprecate(_upgradedAddress, _reason);
    }

    // Called when contract is deprecated
    event Deprecate(address newAddress, string reason);
}


contract UpgradedStandardToken is PausableToken {
    // those methods are called by the legacy contract
    // and they must ensure msg.sender to be the contract address
    function transferByLegacy(address from, address to, uint value) public returns (bool);
    function transferFromByLegacy(address sender, address from, address spender, uint value) public returns (bool);
    function approveByLegacy(address from, address spender, uint value) public returns (bool);
}
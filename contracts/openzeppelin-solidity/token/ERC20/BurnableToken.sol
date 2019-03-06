pragma solidity ^0.4.24;

import "./StandardToken.sol";
import "../../ownership/Ownable.sol";


/**
 * @title Burnable Token
 * @dev Token that can be irreversibly burned (destroyed).
 */
contract BurnableToken is StandardToken, Ownable {
    event Burn(address indexed burner, uint256 value);


    /**
     * @dev Burns a specific amount of tokens.
     * @param _value The amount of token to be burned.
     * @param _who The user whose token should be burned.
     */
    function burn(address _who, uint256 _value) onlyOwner public {
        require(_value <= balances[_who]);
        // no need to require value <= totalSupply, since that would imply the
        // sender's balance is greater than the totalSupply, which *should* be an assertion failure

        balances[_who] = balances[_who].sub(_value);
        totalSupply_ = totalSupply_.sub(_value);
        emit Burn(_who, _value);
        emit Transfer(_who, address(0), _value);
    }
}

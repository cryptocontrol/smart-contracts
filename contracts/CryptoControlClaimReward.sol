pragma solidity ^0.4.22;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./CryptoControlToken.sol";


contract CryptoControlClaimReward is Ownable {
    // This address represents the CryptoControl server
    address public cryptoControlServer = 0x6B3Ae23e0801C5ff0A91921036Dd2ADf0C1512f6;

    // Address of the token smart contract
    CryptoControlToken token;

    // A hashmap to track the nonce for a particular user id. This helps us avoid double
    // spends. Every claim fn. can he invoked only if the nonce passed is greater than 10 from
    // the previous nonce.
    mapping (string => uint256) internal nonces;

    //
    event RewardClaimed(address indexed dest, uint amount, uint nonce);
    event Log1(uint8 dest);
    event Log2(bytes32 dest);


    constructor (address _cryptoControlServer) public {
        cryptoControlServer = _cryptoControlServer;
    }


    /**
     * @dev Set the CryptoControlToken contract
     * @param _token The address of the CryptoControlToken contract
     */
    function setTokenAddress (CryptoControlToken _token) public {
        token = _token;
    }

    function setCryptoControlServer (address newAddress) public onlyOwner {
        cryptoControlServer = newAddress;
    }

    // A public function called by a person
    function claimReward(uint256 amount, uint256 nonce, string userid,
    bytes32 sighash,
    uint8 v, bytes32 r, bytes32 s) external payable
    {
        // Check if the signature matches the data sent
        require(sha256(abi.encodePacked(uint8(amount), msg.sender, uint8(nonce), userid)) == sighash, "Signature mismatch");

        // Check if the signature is sent by the cryptocontrol server
        require(ecrecover(sighash, v, r, s) == cryptoControlServer, "Signature is not from CryptoControl");

        // check the nonce
        require(now - 2 minutes > nonces[userid], "Nonce is too small");
        require(nonce > nonces[userid], "Nonce is smaller than previous nonce");
        nonces[userid] = nonce;

        // If everything is fine, then we mint new tokens for the user
        token.mint(msg.sender, amount);
        // emit RewardClaimed(msg.sender, amount, nonce);
    }
}
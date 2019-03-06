pragma solidity ^0.5.1;

import "./openzeppelin-solidity/ownership/Ownable.sol";
import "./openzeppelin-solidity/token/ERC20/ERC20.sol";
import "./CryptoControlToken.sol";


contract CryptoControlClaimTokens is Ownable {
    // This address represents the CryptoControl server
    address public cryptoControlServer;

    // Address of the token smart contract
    ERC20 public token;

    // A hashmap to track the nonce for a particular user id. This helps us avoid double
    // spends. Every claim fn. can he invoked only if the nonce passed is greater than 10 from
    // the previous nonce.
    mapping (string => uint256) internal nonces;
    mapping (string => uint256) internal timestamps;

    event TokensClaimed(address indexed dest, uint amount, uint nonce, string userid);


    constructor(ERC20 _token, address _ccioServerAddress) public payable {
        token = _token;
        cryptoControlServer = _ccioServerAddress;
    }


    /**
     * @dev Set the CryptoControlToken contract
     * @param _token The address of the CryptoControlToken contract
     */
    function setTokenAddress (ERC20 _token) public onlyOwner {
        token = _token;
    }


    /**
     * @dev Set the wallet address of the CryptoControl server for verification
     * @param _newAddress The address of the CryptoControl server
     */
    function setCryptoControlServer (address _newAddress) public onlyOwner {
        cryptoControlServer = _newAddress;
    }


    /**
     * @dev This function is called by a person to claim a reward from CryptoControl.
     */
    function claimTokens(
        uint256 amount, uint256 nonce, string userid,
        bytes32 sighash, uint8 v, bytes32 r, bytes32 s) external payable {
        // Check if the signature matches the data sent
        require(sha256(abi.encodePacked(address(this), amount, msg.sender, nonce, userid)) == sighash, "Signature mismatch");

        // Check if the signature is sent by the cryptocontrol server
        require(ecrecover(sighash, v, r, s) == cryptoControlServer, "Signature is not from CryptoControl");

        // check the nonce
        // require(now - 2 minutes > nonce, "Nonce is too small");
        require((now - 2 minutes) > timestamps[userid], "A previous claim was made very recently");
        require(nonce > nonces[userid], "Nonce is smaller than previous nonce");
        timestamps[userid] = now;
        nonces[userid] = nonce;

        // If everything is fine, then we send the new tokens to the user
        token.transfer(msg.sender, amount);
        emit TokensClaimed(msg.sender, amount, nonce, userid);
    }
}
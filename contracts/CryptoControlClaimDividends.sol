pragma solidity ^0.4.24;

import "./openzeppelin-solidity/ownership/Ownable.sol";
import "./openzeppelin-solidity/token/ERC20/ERC20.sol";
import "./openzeppelin-solidity/math/SafeMath.sol";


contract CryptoControlClaimDividends is Ownable {
    using SafeMath for uint256;

    // This address represents the CryptoControl server
    address public cryptoControlServer;

    // Address of the token smart contract
    ERC20 public trueUSDToken;

    // A hashmap to track the dividendIds for a particular user id. This helps us avoid users from claiming dividneds twice.
    // Every claim fn. can be invoked only if the dividendId passed is greater than
    // the previous dividendId.
    mapping (string => uint256) dividendIds;
    mapping (string => uint256) internal timestamps;

    // to keep track of dividends being paid in and out
    event Deposited(address indexed payee, uint256 dividendId, uint256 weiAmount);
    event Withdrawn(address indexed payee, uint256 dividendId, uint256 weiAmount);
    mapping(uint256 => uint256) private deposits;

    event DividendsClaimed(address indexed dest, uint256 amount, uint256 dividendId, string userid);


    constructor(ERC20 _trueUSDToken, address _ccioServerAddress) public payable {
        trueUSDToken = _trueUSDToken;
        cryptoControlServer = _ccioServerAddress;
    }


    /**
     * @dev Set the CryptoControlToken contract
     * @param _trueUSDToken The address of the TrueUSD contract
     */
    function setTokenAddress (ERC20 _trueUSDToken) public onlyOwner {
        trueUSDToken = _trueUSDToken;
    }


    /**
     * @dev Set the wallet address of the CryptoControl server for verification
     * @param _newAddress The address of the CryptoControl server
     */
    function setCryptoControlServer (address _newAddress) public onlyOwner {
        cryptoControlServer = _newAddress;
    }


    /**
     * @dev Stores the sent amount as credit to be withdrawn.
     * @param _payee The destination address of the funds.
     */
    function deposit(uint256 dividendId) public onlyOwner payable {
        uint256 amount = msg.value;
        deposits[dividendId] = deposits[dividendId].add(amount);
        emit Deposited(msg.sender, dividendId, amount);
    }


    /**
     * @dev Withdraw accumulated balance for a payee.
     * @param _payee The address whose funds will be withdrawn and transferred to.
     */
    function withdraw(uint256 dividendId) public onlyOwner {
        uint256 payment = deposits[dividendId];
        assert(address(this).balance >= payment);
        deposits[dividendId] = 0;
        msg.sender.transfer(payment);
        emit Withdrawn(msg.sender, dividendId, payment);
    }


    /**
     * @dev This function is called by a person to claim a dividend from CryptoControl.
     */
    function claimDividends(
        uint256 amount, uint256 dividendId, string userid,
        bytes32 sighash, uint8 v, bytes32 r, bytes32 s) external payable
    {
        // Check if the signature matches the data sent
        require(sha256(abi.encodePacked(address(this), amount, msg.sender, dividendId, userid)) == sighash, "Signature mismatch");

        // Check if the signature is sent by the cryptocontrol server
        require(ecrecover(sighash, v, r, s) == cryptoControlServer, "Signature is not from CryptoControl");

        // check the nonce
        // require(now - 10 minutes > nonce, "Nonce is too small");
        require((now - 10 minutes) > timestamps[userid], "A previous claim was made very recently");
        require(dividendId > dividendIds[userid], "Nonce is smaller than previous nonce");
        timestamps[userid] = now;
        dividendIds[userid] = dividendId;

        // If everything is fine, then we send the dividiends to the user
        trueUSDToken.transfer(msg.sender, amount);
        emit DividendsClaimed(msg.sender, amount, dividendId, userid);
    }
}
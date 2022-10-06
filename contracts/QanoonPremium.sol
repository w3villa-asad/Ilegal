//SPDX-License-Identifier: None
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract QanoonPremium is ERC20, Ownable {
    using SafeMath for uint256;

    uint256 constant DELAY = 30 days;
    address[] public stakers;

    mapping(address => uint256) public nextStaking; //next staking 30 days
    mapping(address => uint256) public _timestamps;
    mapping(address => bool) public _blacklisted;

    struct PremiumCoins {
        uint256 stakedBalance;
        uint256 timestamp;
        string uid;
        uint256 expiry;
    }

    mapping(address => PremiumCoins) public premiumCoins; 
    constructor() ERC20("Qanoon Premium", "QPP"){
        
    }
    function mint(address _to, uint256 _amount) public payable onlyOwner {
        require(_to != address(0), "Address Cannot Be a ZERO address");
        require(_amount > 0);
        require(msg.value >= _amount);
        require(balanceOf(msg.sender) >= _amount);
        _mint(_to, _amount);
    }

    function burn(address _from, uint256 _amount) internal {
        require(_amount > 0, "Amount should be greater than zero");
        require(balanceOf(_from) >= _amount, "balance of account should be greater than amount");
        _burn(_from, _amount);
    }

    function addStaker (address _staker) internal {
       require(!_blacklisted[_staker], "Staker is blacklisted");
       stakers.push(_staker);
    }

    function getStakers() public view returns(address[] memory) {
        return stakers;
    }

    function setBlacklistedUser(address account) external onlyOwner {
        require(_blacklisted[account] == false, "Already A Blacklisted User");
        _blacklisted[account] = true;
    }

    function removeBlacklistedUser(address account) external onlyOwner {
        require(_blacklisted[account] == true, "Not A Blacklisted User Already");
        _blacklisted[account] = false;
    }

    // function transfer(address _to, uint256 _amount)

    function stake(uint256 _time, string memory uid, uint256 _amount) public {
        require(!_blacklisted[msg.sender] == true, "You Have Been Blacklisted" );
        require(nextStaking[msg.sender] <= block.timestamp, "Need To Wait For Some More Time To Stake Again");
        
        premiumCoins[msg.sender].timestamp = block.timestamp;

        if (_time == 1){
            premiumCoins[msg.sender].expiry = block.timestamp+30 days;
        }
        else if(_time == 2){
            premiumCoins[msg.sender].expiry = block.timestamp+60 days;
        }
        else if(_time == 3){
            premiumCoins[msg.sender].expiry = block.timestamp+90 days;
        }

        premiumCoins[msg.sender].uid = uid;
        nextStaking[msg.sender] = premiumCoins[msg.sender].expiry + DELAY;
        addStaker(msg.sender);
        _mint(msg.sender, _amount);

    }

    // function unstake()public{
    //     require(_blacklisted[msg.sender] == false, "YOU HAVE been bLACKLISTED");
    //     require(premiumCoins[msg.sender].expiry <= block.timestamp, "Need to wait to unstake tokens");

    //     // transfer(to, amount);
    // }


}

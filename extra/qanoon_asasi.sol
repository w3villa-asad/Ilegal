//SPDX-License-Identifier: None
//
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract QanoonAsasi is ERC20, Ownable, ReentrancyGuard{
    using SafeMath for uint256;
    address public _admin;
    
    // timestamps mapping
    mapping (address => uint256) public _timestamps;

    uint256 public distributed;

        // contract balance
    uint256 public balance;
    
    // initial supply of tokens is 1 million and maximum supply is 100 million
    uint256 public _initialSupply = 1_00_000 ether;
    // uint256 public _maxSupply = 100_000_000 ether;

    uint256 public salePriceUsd = 1000000000000; //$0.000001
    
    // admin mapping
    mapping (address => bool) public _isAdmin;

    mapping (address => uint256) public _toClaim;

    mapping (address => uint256) public  _ethDeposit;


    mapping(address => uint256) public toRefund;

    AggregatorV3Interface internal ethPriceFeed;


/* EVENTS */
    event Bought(address account, uint256 amount);
    event Locked(address account, uint256 amount);
    event Released(address account, uint256 amount);

    event Buy(address indexed from, uint256 amount);
    event Destroyed(uint256 burnedFunds);
    event Transferred(address indexed to, uint256 amount);

    event withdrawnETHDeposit(address indexed to, uint256 amount);
    
    constructor() ERC20('QanoonAsasi', 'QAN') {
        _mint(msg.sender, _initialSupply);
        _admin = msg.sender;
        ethPriceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
    }
    
    // function mint(address to, uint amount) external onlyOwner{
    //     // require(msg.sender == admin, 'only admin');
    //     _mint(to, amount);
    // }
    
    

    function mint(address _account, uint256 amount) public onlyOwner {
        // should not reach max supply
        require(totalSupply().add(amount) <= _initialSupply, "ERC20: cap exceeded");
    
        _mint(_account, amount);
    }
    

    // admin can mint
    function mintAdmin(address _account, uint256 amount) public {
        require(_isAdmin[_account] == true, "ERC20: admin only");
        _mint(_account, amount);
    }
    
    // add admin to the list of admins
    function addAdmin(address _account) public onlyOwner {
        _isAdmin[_account] = true;
    }
    
    // remove admin from the list of admins
    function removeAdmin(address _account) public onlyOwner {
        _isAdmin[_account] = false;
    }

    function salePriceEth() public view returns (uint256) {
            (, int256 ethPriceUsd, , , ) = ethPriceFeed.latestRoundData();
            uint256 rbthlpriceInEth = (salePriceUsd.mul(10**18)).div(uint256(ethPriceUsd).mul(10**10));

            return rbthlpriceInEth;
    }   

    function computeTokensAmount(uint256 funds) public view returns (uint256, uint256) {
        uint256 salePrice = salePriceEth();
        uint256 tokensToBuy = (funds.div(salePrice)).mul(10**18); // 0.5 6.5 = 6

        uint256 exceedingEther;
        
        return (tokensToBuy, exceedingEther);
    }
    
    function burn(uint amount) public {
        _burn(msg.sender, amount);
    }

        // users can claim rbthl tokens
    function claim() external {
        require(_ethDeposit[msg.sender] > 0, "No ETH deposit to claim");

        transfer(msg.sender, _toClaim[msg.sender]);
    }

    function buy() public payable nonReentrant {

        require(totalSupply() > 0, "everything was sold");

        // compute the amount of token to buy based on the current rate
        (uint256 tokensToBuy, uint256 exceedingEther) = computeTokensAmount(
            msg.value
        );
        _toClaim[msg.sender] = _toClaim[msg.sender].add(tokensToBuy);


        balance += msg.value;   // add the funds to the balance

        // refund eventually exceeding eth
        if (exceedingEther > 0) {
            uint256 _toRefund = toRefund[msg.sender] + exceedingEther;
            toRefund[msg.sender] = _toRefund;
        }
        distributed = distributed.add(tokensToBuy);

        // Mint new tokens for each submission

        // eth deposit of user is stored in _ethDeposit
        _ethDeposit[msg.sender] = _ethDeposit[msg.sender].add(msg.value);

        emit Buy(msg.sender, tokensToBuy);
    }  
    
}
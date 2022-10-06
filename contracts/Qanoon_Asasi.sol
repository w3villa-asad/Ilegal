//SPDX-License-Identifier: None
//
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract QanoonAsasi is ERC20, Ownable, ReentrancyGuard{
    using SafeMath for uint256;
    
    // timestamps mapping
    mapping (address => uint256) public _timestamps;

    // initial supply of tokens is 1 million and maximum supply is 100 million
    uint256 public _initialSupply = 1_00_000 ether;
    
    // admin mapping
    mapping (address => bool) public _isAdmin;
    uint256 public currentSupply = 0;

    constructor() ERC20('QanoonAsasi', 'QAN') {
        // _mint(msg.sender, _initialSupply);
        _isAdmin[msg.sender] = true;
    }

    function mint(address _account, uint256 amount) public onlyOwner {
        // should not reach max supply
        require(totalSupply().add(amount) >= _initialSupply, "ERC20: cap exceeded");
    
        _mint(_account, amount);
    }

    function buy(address _account, uint256 _amount) public {
        require(msg.sender != address(0), "Cannot Mint To A Zero Address");
        currentSupply = currentSupply + _amount ;
        require(currentSupply <= _initialSupply, "Supply Not Enough To Buy Tokens");
        _mint(_account, _amount);
    }

    function increaseSupply(uint256 _amount) public onlyOwner {
       _initialSupply =  _initialSupply + _amount;
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
    
    function burn(uint256 _amount) public {
        currentSupply = currentSupply - _amount ;
        _burn(msg.sender, _amount);
    }

    // function burnTokens(uint256 amount) public {
        
    //     transfer(address(this), amount);
    // }

    function totalSupply() public override view returns(uint256){
        return _initialSupply;
    }

}
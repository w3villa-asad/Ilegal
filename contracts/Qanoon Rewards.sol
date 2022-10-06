//SPDX-License-Identifier: None

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract QanoonRewards is ERC20, Ownable {
    
    using SafeMath for uint256;
    uint256 public _initialSupply = 1_000_000 ether;
    
    mapping (address => bool) public _isAdmin;
    uint256 public currentSupply = 0;

    constructor() ERC20('QanoonRewards', 'QAN') {
        // _mint(msg.sender, _initialSupply);
        _isAdmin[msg.sender] = true;
    }

    function mint(address _account, uint256 amount) public onlyOwner {
        _mint(_account, amount);
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

    function burn(uint256 amount) public  {
        currentSupply = currentSupply - amount ;
        _burn(msg.sender, amount);
    }

    function totalSupply() public override view returns(uint256){
        return _initialSupply;
    }

}


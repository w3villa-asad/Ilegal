//SPDX-License-Identifier: None

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Qanoon is ERC20, Ownable{
    using SafeMath for uint256;
    address public _admin;
    
    // timestamps mapping
    mapping (address => uint256) public _timestamps;

    // initial supply of tokens is 1 million and maximum supply is 100 million
    uint256 public _initialSupply = 1_000_000 ether;
    uint256 public _maxSupply = 50_000_000 ether;



    // admin mapping
    mapping (address => bool) public _isAdmin;

    constructor() ERC20('Qanoon', 'QAN') {
        _mint(msg.sender, _initialSupply);
        _admin = msg.sender;
    }

    // function mint(address to, uint amount) external onlyOwner{
    //     // require(msg.sender == admin, 'only admin');
    //     _mint(to, amount);
    // }

    function mint(address _account, uint256 amount) public onlyOwner {
        // should not reach max supply
        require(totalSupply().add(amount) <= _maxSupply, "ERC20: cap exceeded");

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

    function burn(uint amount) public {
        _burn(msg.sender, amount);
    }

}
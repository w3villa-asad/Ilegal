//SPDX-License-Identifier: None

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract QanoonRewards is ERC20, Ownable {
    
    using SafeMath for uint256;
    uint256 public _initialSupply = 1_000_000 ether;


    constructor() ERC20('QanoonRewards', 'QAN') {
        _mint(msg.sender, _initialSupply);
    }

    function mint(address _account, uint256 amount) public onlyOwner {
        _mint(_account, amount);
    }

    function burn(uint amount) public  {
        
        _burn(msg.sender, amount);
    }

}


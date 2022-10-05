//SPDX-License-Identifier: None

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";


contract QanoonComplementary is ERC20, Ownable {
    
    using SafeMath for uint256;
    uint256 _initialSupply = 20000 ether;
    uint256 maxSupply;
    uint256 public currentSupply = 0;

    constructor() ERC20("QanoonComplementary", "QANC") {
        //mint initial supply
        maxSupply = _initialSupply;
        _mint(address(this), _initialSupply);
    }

    function mint(address _to, uint256 _amount) public {
        //check if _to is a contract
        currentSupply = currentSupply + _amount;
        require(currentSupply <= _initialSupply, "Please Enter A Valid Amount Available to Supply");
        require(_to != address(0), "Address is not a contract");
        //check if _to is a contract");
        //check if _amount is greater than 0
        require(_amount > 0, "Amount must be greater than 0");
        _mint(_to, _amount);
        // transferFrom(address(this), _to, _amount);
    }

    function burn(uint256 _amount) public onlyOwner {
        _burn(msg.sender,_amount);
        currentSupply = currentSupply - _amount;

    }

    function totalSupply() public override view returns (uint256){
        return maxSupply;
    }

}

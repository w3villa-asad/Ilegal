//SPDX-License-Identifier: None

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";


contract QanoonComplementary {
    address public owner
    address public beneficiary
    uint public amount
    uint public timestamp

    constructor(address _beneficiary, uint _amount, uint _timestamp
    ) public payable {
        beneficiary = _beneficiary;
        amount = _amount;
        timestamp = _timestamp;
    }

    function withdraw() public {

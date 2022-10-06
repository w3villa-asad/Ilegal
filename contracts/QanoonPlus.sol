// SPDX-License-Identifier: None

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

interface IQanoonAsasi {
    function balanceOf(address _owner)external returns (uint256);
    function transfer(address _to, uint256 _value)external;
}

contract QanoonPlus is ERC20, Ownable {
    
    using SafeMath for uint256;

    IQanoonAsasi public qanoonAsasi;

    uint256 _initialSupply = 90_000 ether;

    uint256 constant DELAY = 182 days; // 182 days = 6 months

    mapping(address => uint256) public _timestamps;

    mapping(address => bool) public _isInvestor;

    uint256 currentInvestorSupply = 0;
    
    constructor (address _qanoonAsasi) ERC20("Qanoon Plus","QANP"){
        // _mint(msg.sender, _initialSupply);
        qanoonAsasi = IQanoonAsasi(_qanoonAsasi);
    }

    function buy(address _account, uint256 _amount) public {
        // require(!address(0)=true, "");
        _mint(_account, _amount);
        _timestamps[_account]=block.timestamp;
        _timestamps[_account]=block.timestamp + DELAY; // it will take 6 months after buying token

    }

    function increaseSupply(uint256 _amount) public onlyOwner{
        _initialSupply += _amount;
    }


    //90,000 qanoon plus coins shall be issued to small investors
    function issueInvestorSupply(address _account, uint256 _amount) public {
        require(_isInvestor[_account] == true, "You Are Not An Investor Yet");
        currentInvestorSupply = currentInvestorSupply + _amount;
        require(currentInvestorSupply <= _initialSupply, "Supply Is Not Enough For Investment");
        _mint(_account, _amount);
    }

    // Value shall double every 24hours or when every purchase is being made
    function doubleUpSupply(address _account, uint256 _amount) public {
        require(_isInvestor[_account] == true, "You Are Not An Investor Yet");
        uint256 amt = _amount + _amount ;
        _mint(_account, amt);
    }

    // add investors
    function addInvestor(address _account)public {
        require(_isInvestor[_account] == false , "You are Already An Investor");

        _isInvestor[_account] = true;
    }

    //add investors
    function removeInvestor(address _account)public {
        require(_isInvestor[_account] == true, "You Are Not An Investor Yet");
        _isInvestor[_account] = false;
    }

    function buyUsingAsasi(address _owner, uint256 _amount) public onlyOwner {
        uint256 val = 10000 * (10**18) ;
        require(qanoonAsasi.balanceOf(_owner)>= val  , "Need Atleast 10000 Qanoon Rewards To Buy Qanoon Plus Token");

        uint256 newval = _amount.div(1e18); // this will return number of tokens user wants to buy in exchange of rewards token

        uint256 newchange = qanoonAsasi.balanceOf(_owner).div(1e18); // this will return actual number of rewards token

        uint256 newval1 = newchange.div(10000);

        if(newval1 >= newval){
            _mint(_owner, _amount);
        }
        else{
            require(false, "Not Enough Tokens to purchase");
        }

    }

    function totalSupply()public override view returns(uint256){
       return _initialSupply;
    }

}
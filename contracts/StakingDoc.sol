//SPDX-License-Identifier: None

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract StakingDoc is Ownable {

    address[] public stakers;

    IERC20 qanoon;


    uint256 constant DELAY = 30 days;

    constructor(address _qanoon) public {
        qanoon = IERC20(_qanoon);
        // stakers = new address[](0);

    }

    struct DocInfo{
        address docAddr;
        string docParams;
        string docId;
        uint256 timestamp;
        uint256 expiry;
        string uri;
    }

    mapping (address => DocInfo) public docInfo;

    // to blacklist user for irrelevant Docs
    mapping (address => bool) public _blacklisted;

    function getStakers() public view returns(address[] memory) {
        return stakers;
    }

    // add staker to the list of stakers
    function addStaker(address _staker) public onlyOwner {
        require(!_blacklisted[_staker], "Account is blacklisted");
        stakers.push(_staker);
    }

    // remove staker from the list of stakers
    // function removeStaker(address _staker) external onlyOwner {
    //     // require(!_blacklisted[_staker], "Account is blacklisted");
    //     stakers.remove(_staker);
    // }

    // documents info gathering
    function getDocInfo(address _account) public view returns(DocInfo memory) {
        return docInfo[_account];
    }

    // addBlacklist
    function addBlacklist(address _account) external onlyOwner {
        _blacklisted[_account] = true;
    }

    // removeBlacklist
    function removeBlacklist(address _account) external onlyOwner {
        _blacklisted[_account] = false;
    }

    // document staking function with params
    function stake(uint256 types, string memory uri, address docAddr, string memory docParams, string memory docId) public {
        require(!_blacklisted[msg.sender] == true, "Account is blacklisted");

        docInfo[msg.sender].docAddr = docAddr;
        docInfo[msg.sender].docParams = docParams;
        docInfo[msg.sender].docId = docId;
        docInfo[msg.sender].uri = uri;

        if(types == 1) {
            docInfo[msg.sender].timestamp = block.timestamp;
            docInfo[msg.sender].expiry = block.timestamp + 30 days;
        } else if(types == 2) {
            docInfo[msg.sender].timestamp = block.timestamp;
            docInfo[msg.sender].expiry = block.timestamp + 60 days;
        } else if(types == 3) {
            docInfo[msg.sender].timestamp = block.timestamp;
            docInfo[msg.sender].expiry = block.timestamp + 90 days;
        } else if(types == 4) {
            docInfo[msg.sender].timestamp = block.timestamp;
            docInfo[msg.sender].expiry = block.timestamp + 120 days;
        }

        addStaker(msg.sender);
    }

    // document unstaking still needs to be discussed
    function unstake() public {
        require(!_blacklisted[msg.sender] == true, "Account is blacklisted");
        
        

    }

}
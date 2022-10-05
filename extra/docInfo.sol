//SPDX-License-Identifier: None

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract StakingDoc is Ownable {

    address[] public stakers;

    IERC20 qanoon;


    uint256 constant DELAY = 30 days;

    constructor(address _qanoon) {
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
        string docType;
    }

    


    // mapping (address => DocInfo) public docInfo;

    mapping (address => DocInfo[]) public docInfo;

    // store documents uploaded by one user using uid
    // mapping (address => mapping(string => DocInfo)) public _documents; // string is docId

    mapping (address => string[]) public _documents;

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


    // addBlacklist
    function addBlacklist(address _account) external onlyOwner {
        _blacklisted[_account] = true;
    }

    // removeBlacklist
    function removeBlacklist(address _account) external onlyOwner {
        _blacklisted[_account] = false;
    }

    // document staking function with params
    function stake(uint256 time, string memory _doctype, string memory uri, address docAddr, string memory docParams, string memory docId) public {
        require(!_blacklisted[msg.sender] == true, "Account is blacklisted");

        // docInfo[msg.sender].docAddr = docAddr;
        // docInfo[msg.sender].docParams = docParams;
        // docInfo[msg.sender].docId = docId;
        // docInfo[msg.sender].uri = uri;

        uint256 exp;
        uint256 time1;
        // _doctype = "resolutions";
        string memory doctype;

        if(time == 1) {
            time1 = block.timestamp;
            exp = block.timestamp + 30 days;
        } else if(time == 2) {
            time1 = block.timestamp;
            exp = block.timestamp + 60 days;
        } else if(time == 3) {
            time1 = block.timestamp;
            exp = block.timestamp + 90 days;
        } else if(time == 4) {
            time1 = block.timestamp;
            exp = block.timestamp + 120 days;
        }

        addStaker(msg.sender);

        if(keccak256(abi.encodePacked(_doctype)) == keccak256(abi.encodePacked("resolutions"))){
            doctype = _doctype;
        }
        else if(keccak256(abi.encodePacked(_doctype)) == keccak256(abi.encodePacked("contracts"))){
            doctype = _doctype;
        }
        else if(keccak256(abi.encodePacked(_doctype)) == keccak256(abi.encodePacked("certificates"))){
            doctype = _doctype;
        }
        else if(keccak256(abi.encodePacked(_doctype)) == keccak256(abi.encodePacked("affidavits"))){
            doctype = _doctype;
        }
        else {
            require(false ,"type is not correct");
        }

        DocInfo memory abc = DocInfo({
        docAddr : docAddr,
        docParams : docParams,
        timestamp : time1,
        expiry : exp,
        docId : docId,
        uri : uri,
        docType : doctype
        });
        docInfo[msg.sender].push(abc);

    }

    function getUsers(address _account)public view returns(DocInfo[] memory){
        return docInfo[_account];
    }

}
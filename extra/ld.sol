/**
 *Submitted for verification at Etherscan.io on 2021-02-18
*/

pragma solidity ^0.8.0;

contract POI
{
  address owner;
  mapping(bytes32=>string) pubKeys;
  mapping(bytes32=>uint256) invalidations;
  mapping(bytes32=>bytes32) roots;
  mapping(bytes32=>uint256) time;

  constructor(){
  owner = msg.sender;
}

  modifier onlyOwner() {
  require(msg.sender == owner);
  _;
}

  function getPubKey(bytes32 name) public view returns(string memory){
  return pubKeys[name];
}

  function setPubKey(bytes32 name, string memory key)
  public
  onlyOwner
  payable
  {
    require(bytes(pubKeys[name]).length==0);
    pubKeys[name]=key;
  }

  function invalidate(bytes32 docHash)
  public
  onlyOwner
  payable
  {
    require(invalidations[docHash]==0);
    invalidations[docHash]=block.timestamp;
  }

  function getInvalidated(bytes32 docHash) public view returns(uint256){
  return invalidations[docHash];
}

  function getRootPubKey(bytes32 root) public view returns(string memory){
  return pubKeys[roots[root]];
}

  function getAuthority(bytes32 root) public view returns(bytes32){
  return roots[root];
}

  function getTime(bytes32 root) public view returns(uint256){
  return time[root];
}

  function setRoot(bytes32 root, bytes32 name)
  public
  onlyOwner
  payable
  {
    require(roots[root]==0x0);
    roots[root]=name;
    time[root]=block.timestamp;
  }



}
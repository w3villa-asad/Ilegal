//SPDX-License-Identifier: None

pragma solidity ^0.8.13;

contract Document {
    address public owner;
    string public docType;
    address public DocAddr;
    string  public docParams;

    constructor(address _owner, string memory _docType,string memory _docParams) payable {
        owner = _owner;
        docType = _docType;
        DocAddr = address(this);
        docParams = _docParams;
    }
}

contract DocumentFactory {
    Document[] public documents;

    struct DocInfo {
        string types;
    }

    mapping (address => DocInfo) public docInfo;
    

    function setType(string memory types ) public {
        if(keccak256(abi.encodePacked(types)) == keccak256(abi.encodePacked("resolutions"))){
            docInfo[msg.sender].types = types;
        }
        else if(keccak256(abi.encodePacked(types)) == keccak256(abi.encodePacked("contracts"))){
            docInfo[msg.sender].types = types;
        }
        else if(keccak256(abi.encodePacked(types)) == keccak256(abi.encodePacked("certificates"))){
            docInfo[msg.sender].types = types;
        }
        else if(keccak256(abi.encodePacked(types)) == keccak256(abi.encodePacked("affidavits"))){
            docInfo[msg.sender].types = types;
        }
        else {
            require(false ,"type is not correct");
        }
    }

    function create(address _owner, string memory _docType, string  memory _docParams) public {
        Document document = new Document(_owner, _docType, _docParams);
        documents.push(document);
    }

    function createAndSendEther(address _owner, string memory _docType, string  memory _docParams) public payable {
        Document document = (new Document){value: msg.value}(_owner, _docType,_docParams);
        documents.push(document);
    }

    function create2(
        address _owner,
        string memory _docType,
        bytes32 _salt,
        string  memory _docParams
    ) public {
        Document document = (new Document){salt: _salt}(_owner, _docType,_docParams);
        documents.push(document);
    }

    function create2AndSendEther(
        address _owner,
        string memory _docType,
        bytes32 _salt,
        string memory _docParams
    ) public payable {
        Document document = (new Document){value: msg.value, salt: _salt}(_owner, _docType,_docParams);
        documents.push(document);
    }

    function getDocument(uint _index)
        public
        view
        returns (
            address owner,
            string memory docType,
            address DocAddr,
            uint balance,
            string memory docParams
        )
    {
        Document document = documents[_index];

        return (document.owner(), document.docType(), document.DocAddr(), address(document).balance, document.docParams());
    }
}

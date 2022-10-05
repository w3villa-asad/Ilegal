pragma solidity ^0.4.24;

contract DocumentStorage {
    struct DocInfo {
        address docAddr;
        string uri;
        bytes32 uid;
        bytes32 docParams;
        bytes32 docId;
        bytes32 docType;
    }
    mapping(bytes32 => DocInfo) public docs;

    function stakeDocument(
        bytes32 uid,
        bytes32 docParams,
        bytes32 docId,
        bytes32 docType
    ) public {
        require(docs[_uid].uid == 0);
        docs[_uid] = DocInfo(
            msg.sender,
            msg.sender.toString(),
            uid,
            docParams,
            docId,
            docType
        );
    }

    function getDocument(bytes32 uid)
        public
        view
        returns (
            address,
            string,
            bytes32,
            bytes32,
            bytes32,
            bytes32
        )
    {
        return (
            docs[_uid].docAddr,
            docs[_uid].uri,
            docs[_uid].uid,
            docs[_uid].docParams,
            docs[_uid].docId,
            docs[_uid].docType
        );
    }

    function getUserDocuments(bytes32 uid) public view returns (uint256) {
        return docs[_uid].uid;
    }
}

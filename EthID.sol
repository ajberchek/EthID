pragma solidity ^0.4.4;

contract EthID
{
    mapping (address => string) public EIDs;
    mapping (address => address[]) public trustedEIDManagers;
    address[] quorum;

    function EthID(address[] toBeQuorum) public {
        quorum = toBeQuorum;
    }

}

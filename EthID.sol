pragma solidity ^0.4.4;

contract EthID
{
    mapping (address => string) public EIDs;
    mapping (address => address[]) public trustedEIDManagers;
    address[] quorum;

    function EthID(address[] toBeQuorum) public {
        quorum = toBeQuorum;
    }

    function present(address[] addrSet, address addr) constant returns (bool)
    {
        //For loop to check presence of addr in addrSet
        for (uint8 i = 0; i < addrSet.length; i++) {
            if (addr == addrSet[i]) { return true; }
        }

        // The address was not present
        return false;
    }

    modifier isQuorumMember(address addr)
    {
        require(present(quorum,addr) == true);
    }

    function addEID(address addr, string name) isQuorumMember(msg.sender)
    {
        //Add to a struct the count of quorum members voting to add someone
        //if count is majority then add the EID
    }

    function removeEID(address addr)
    {
        //Get addr's trustedEIDManagers, make sure the sender is in that list, and 
        //increment the number of people voting to remove and if it is majority then remove
    }

    function getAddr(string name)
    {
        //return the address associated with the name and -1 if none
    }

}

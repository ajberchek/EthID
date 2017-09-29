pragma solidity ^0.4.4;

contract EthID
{
    mapping (address => string) public EIDs;
    mapping (address => address[]) EIDsToAdd;
    mapping (address => address[]) EIDsToRemove;

    mapping (address => address[]) public trustedEIDManagers;

    address[] public quorum;

    function EthID(address[] toBeQuorum) public 
    {
        quorum = toBeQuorum;
    }

    function present(address[] addrSet, address addr) public constant returns (bool)
    {
        // Return whether address was present
        for (uint8 i = 0; i < addrSet.length; i++) 
        {
            if (addrSet[i] == addr) { return true; }
        }

        return false;
    }

    modifier isQuorumMember(address addr)
    {
        require(present(quorum, addr) == true);
        _;
    }

    function addEID(address addr, string name) isQuorumMember(msg.sender) public
    {
        if(getAddr(name) != address(0))
        {
            address[] signatures = EIDsToAdd[addr];
            if(present(signatures, msg.sender) == false)
            {
                signatures.push(msg.sender);
                if(2*signatures.length > quorum.length)
                {
                    EIDs[addr] = name;
                    delete EIDsToAdd[addr];
                }
                else
                {
                    EIDsToAdd[addr] = signatures;
                }
            }
        }
    }

    function removeEID(address addr) public
    {
        //Get addr's trustedEIDManagers, make sure the sender is in that list, and 
        //increment the number of people voting to remove and if it is majority then remove
    }

    function getAddr(string name) public constant returns (address)
    {
        //return the address associated with the name and -1 if none
        for (uint8 i = 0; i < EIDs.length; i++) 
        {
            if (EIDs[i] == name) { return EIDs[i]; }
        }
        
        return address(0);
    }

}

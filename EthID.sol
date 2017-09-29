pragma solidity ^0.4.4;

contract EthID
{
    mapping (address => string) public EIDs;
    mapping (address => address[]) public EIDsToAdd;
    mapping (address => address[]) public EIDsToRemove;

    mapping (address => address[]) public trustedEIDManagers;

    address[] public quorum;

    function EthID(address[] toBeQuorum) public
    {
        quorum = toBeQuorum;
    }

    function present(address[] addrSet, address addr) constant returns (bool)
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
    }

    //TODO fix exploit:
    //Last signer can change name arbitrarily, store name as well as signers
    function addEID(address addr, string name) isQuorumMember(msg.sender)
    {
        //Ensure the address we are suggesting isnt already an EID
        if(getAddr(name) == address(0))
        {
            //Verify the quorum member isnt already a suggester for this addr
            address[] signatures = EIDsToAdd[addr];
            if(present(signatures, msg.sender) == false)
            {
                //Add them to the list of signatures
                signatures.push(msg.sender);
                if(2*signatures.length > quorum.length)
                {
                    //We have reached majority, add the addr and delete
                    //this suggested list
                    EIDs[addr] = name;
                    delete EIDsToAdd[addr];
                }
                else
                {
                    //Reset the map to have this larger list of signatures
                    EIDsToAdd[addr] = signatures;
                }
            }
        }
    }

    function setTrustedEID(address[] addrs)
    {
        if(EIDs[msg.sender] != 0 && trustedEIDManagers[msg.sender] == 0)
        {
            trustedEIDManagers[msg.sender] = addrs;
        }
    }

    function removeEID(address addr)
    {
        //Get addr's trustedEIDManagers, make sure the sender is in that list, and 
        //increment the number of people voting to remove and if it is majority then remove
        if(EIDs[addr] != 0)
        {
            address[] remSigs = EIDsToRemove[addr];
            address[] trusted = trustedEIDManagers[addr];
            if(present(trusted,msg.sender) == true && present(remSigs,msg.sender) == false)
            {
                remSigs.push(msg.sender);
                if(2*remSigs.length > trusted.length)
                {
                    //We have reached majority, add the addr and delete
                    //this suggested list
                    delete EIDs[addr];
                    delete EIDsToRemove[addr];
                }
                else
                {
                    //Reset the map to have this larger list of signatures
                    EIDsToRemove[addr] = remSigs;
                }
            }
        }
    }

    function getAddr(string name) constant returns (address)
    {
        //return the address associated with the name and -1 if none
        for (uint8 i = 0; i < EIDs.length; i++)
        {
            if (EIDs[i] == name) { return EIDs[i]; }
        }

        return address(0);
    }

}

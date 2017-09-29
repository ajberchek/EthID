pragma solidity ^0.4.4;

contract EthID
{
    address public owner;

    function EthID() public {
        owner = msg.sender;
    }

}

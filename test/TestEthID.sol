pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/EthID.sol";

contract TestEthID {

	function testAdd() {
		EthID eid = EthID(DeployedAddresses.EthID());

		address andrewAddr = address(0x884025c566d2f940363381ddded0a16838a5feac);
		address badAddr = address(0x1111111111111111111111111111111111111111);

		eid.addEID(andrewAddr, "andrew");

		Assert.equal(eid.getAddr("andrew"), andrewAddr, "Should be able to add address and get it back later.");
		Assert.notEqual(eid.getAddr("andrew"), badAddr, "Shouldn't match bad address.");
	}

    function testRemove() {
		EthID eid = EthID(DeployedAddresses.EthID());

		address andrewAddr = address(0x884025c566d2f940363381ddded0a16838a5feac);
		address badAddr = address(0x1111111111111111111111111111111111111111);

		eid.addEID(DeployedAddresses.EthID(), "andrew");
		Assert.equal(eid.getAddr("andrew"), andrewAddr, "Should be able to add address and get it back later.");

        address[] addr;
        addr.push(DeployedAddresses.EthID());

        eid.setTrustedEID(addr);

        eid.removeEID(DeployedAddresses.EthID());
		Assert.notEqual(eid.getAddr("andrew"), DeployedAddresses.EthID(), "Shouldn't match bad address.");
	}

}

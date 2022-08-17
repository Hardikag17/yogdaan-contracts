// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "./structs.sol";

contract Bank is structs {
    function addBank(
        string memory _name,
        address _walletAddress,
        string memory _code,
        uint256 _intrestRate
    ) public {
        uint256 id = ++numBanks;
        banks[id] = Bank(id, _name, _walletAddress, _code, _intrestRate);
    }

    // fetch functions

    function getbanks(uint256 bankid) public view returns (Bank memory) {
        return banks[bankid];
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "./structs.sol";

contract modifiers is structs {
    modifier onlySHG(uint256 shgid) {
        require(shgs[shgid].id != 0);
        _;
    }

    modifier onlyUser(uint256 userid) {
        require(users[userid].id != 0);
        _;
    }

    modifier onlyBank(uint256 bankid) {
        require(banks[bankid].id != 0);
        _;
    }
}

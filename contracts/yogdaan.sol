// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "./lib/Bank.sol";
import "./lib/SHG.sol";
import "./lib/User.sol";

contract Yogdaan is Bank, SHG, User {
    address admin;

    constructor() {
        admin = msg.sender;
    }
}

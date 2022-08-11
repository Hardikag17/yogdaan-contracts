// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "./structs.sol";

contract User is structs {
    function login() public view returns (bool) {
        return (users[addressToUser[msg.sender]].walletAddress == msg.sender);
    }

    function addUser(
        string memory name,
        string memory aadhar,
        uint256 mobno,
        string memory fatherName,
        Gender gender
    ) public {
        require(
            users[addressToUser[msg.sender]].walletAddress != msg.sender,
            "Already Registered"
        );
        uint256 id = ++numUsers;
        addressToUser[msg.sender] = id;
        users[id] = User(
            numUsers++,
            name,
            aadhar,
            mobno,
            fatherName,
            msg.sender,
            new uint256[](0),
            0,
            UserType.NONE,
            gender
        );
    }
}

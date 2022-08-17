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
            0, // SHG id is zero inttially as a placeholder for every user
            UserType.NONE,
            gender
        );
    }

    // Request functions for user

    function makeRequest(
        uint256 _shgid,
        uint256 _userId,
        uint256 _amount,
        string memory _description
    ) public {
        uint256 _requestId = ++numRequests;
        requests[_requestId] = Request(
            _requestId,
            _userId,
            _amount,
            _description,
            _shgid,
            new Status[](0)
        );
    }

    function deleteRequest() public {}

    function approveRequest() public {}

    // Repay functions for user

    function payEMI() public {}

    function getEMI() public {}

    function updateLoanAmount() internal {}

    function flagDefaulters() public {}
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "./lib/structs.sol";

contract Yogdaan is structs {
    function addBank() public {}

    function addSHGMember(uint256 userid, uint256 shg) public {
        require(users[userid].shgid == shg, "User already added");
        users[userid].shgid = shg;
        users[userid].userType = UserType.MEMBER;
        shgs[shg].users.push(userid);
    }

    function removeSHGMember() public {}

    function updateMemberRole(uint256 id, UserType updatedType) public {
        // TODO: add requires
        users[id].userType = updatedType;
    }

    function makeRequest() public {}

    function approveRequest() public {}

    function sendGrant(uint256 requestid) public {
        require(
            users[addressToUser[msg.sender]].userType == UserType.TREASURER,
            "Unauthorized reqest"
        );
        require(
            requests[requestid].status.length > 0 &&
                requests[requestid]
                    .status[requests[requestid].status.length - 1]
                    .requestStatus ==
                RequestStatus.APPROVED,
            "Unapproved request"
        );
        payable(users[requests[requestid].userId].walletAddress).transfer(
            requests[requestid].amount
        );
    }

    function forwordRequest() public {}

    // Repay functions for user

    function payEMI() public {}

    function getEMI() public {}

    function updateLoanAmount() internal {}

    function flagDefaulters() public {}

    // fetch functions

    function getbanks() public {}

    function getSHGs() public {}

    function getRequests() public {}

    function getSHGMembers() public {}
}

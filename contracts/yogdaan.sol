// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "./lib/structs.sol";

contract Yogdaan is structs {
    mapping(uint256 => User) users;
    mapping(uint256 => SHG) shgs;
    mapping(address => uint256) addressToUser;
    mapping(uint256 => Loan) loans;
    mapping(uint256 => Request) requests;
    uint256 numUsers;
    uint256 numSHGs;

    function addBank() public {}

    function addSHGMember(uint256 userid, uint256 shg) public {
        require(users[userid].shgid == shg, "User already added");
        users[userid].shgid = shg;
        users[userid].userType = UserType.MEMBER;
        shgs[shg].users.push(userid);
    }

    function deleteIndex(uint256[] memory array, uint256 index)
        internal
        pure
        returns (uint256[] memory)
    {
        require(index < array.length);

        for (uint256 i = index; i < array.length - 1; i++) {
            array[i] = array[i + 1];
        }
        delete array[array.length - 1];
        return array;
    }

    function check(uint256[] memory array, uint256 id)
        internal
        pure
        returns (bool)
    {
        for (uint256 i = 0; i < array.length - 1; i++) {
            if (array[i] == id) {
                return true;
            }
        }
        return false;
    }

    function getIndex(uint256[] memory array, uint256 id)
        internal
        pure
        returns (uint256)
    {
        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] == id) {
                return i;
            }
        }
    }

    function removeSHGMember(uint256 userid, uint256 shgid) public {
        SHG storage shg = shgs[shgid];
        require(
            check(shg.users, shgid),
            "User is already not a part of the SHG"
        );

        uint256 index = getIndex(shg.users, userid);
        uint256[] memory newusers = deleteIndex(shg.users, index);
        shg.users = newusers;
    }

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

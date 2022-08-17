// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "./structs.sol";
import "./helpers.sol";

contract SHG is structs, helpers {
    function addSHG(
        uint256[] memory members,
        uint256 president,
        string memory name,
        Location memory location,
        string memory dateOfFormation
    ) public {
        require(members.length >= 7, "Atleast 7 members required");
        uint256 id = ++numSHGs;
        shgs[id] = SHG(
            id,
            members,
            name,
            location,
            dateOfFormation,
            0,
            0,
            new uint256[](0),
            new uint256[](0)
        );
        for (uint256 i = 0; i < members.length; i++) {
            users[members[i]].userType = members[i] == president
                ? UserType.PRESIDENT
                : UserType.MEMBER;
        }
    }

    function addSHGMember(uint256 userid, uint256 shg) public {
        require(users[userid].shgid == shg, "User already added");
        users[userid].shgid = shg;
        users[userid].userType = UserType.MEMBER;
        shgs[shg].users.push(userid);
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

    function forwordRequest(uint256 requestid, uint256 forwordid) public {
        Request storage req = requests[requestid];
        // check if request id is valid
        // check if request is not already approved
        // check if forword id is valid

        Status storage newStatus = req.status.push();
        newStatus.Id = forwordid;
        newStatus.requestStatus = RequestStatus.FORWARDED;
    }

    // fetch functions
    function getSHG(uint256 shgid) public view returns (SHG memory) {
        return shgs[shgid];
    }

    function getRequests(uint256 requestid)
        public
        view
        returns (Request memory)
    {
        return requests[requestid];
    }

    function getSHGMembers(uint256 shgid)
        public
        view
        returns (uint256[] memory)
    {
        return shgs[shgid].users;
    }
}

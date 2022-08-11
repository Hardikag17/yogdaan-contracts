// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "./structs.sol";

contract SHG is structs {
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
}

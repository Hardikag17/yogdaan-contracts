// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "./structs.sol";
import "./helpers.sol";
import "./modifiers.sol";

contract SHG is structs, helpers, modifiers {
    function addSHG(
        uint256[] memory members,
        uint256 president,
        uint256 treasurer,
        string memory name,
        string memory _state,
        string memory _district,
        string memory _blockName,
        string memory _panchyatName,
        string memory _villageName,
        string memory dateOfFormation,
        uint256 _baseIntrest
    ) public {
        require(members.length >= 7, "Atleast 7 members required");
        uint256 id = ++numSHGs;

        Location memory newlocation = Location({
            state: _state,
            district: _district,
            blockName: _blockName,
            panchyatName: _panchyatName,
            villageName: _villageName
        });

        shgs[id] = SHG(
            id,
            members,
            name,
            newlocation,
            dateOfFormation,
            0,
            0,
            new uint256[](0),
            new uint256[](0),
            _baseIntrest
        );
        for (uint256 i = 0; i < members.length; i++) {
            uint256 userid = members[i];
            users[userid].userType = UserType.MEMBER;
            if (userid == president)
                users[userid].userType = UserType.PRESIDENT;
            if (userid == treasurer)
                users[userid].userType = UserType.TREASURER;
            addressToSHGid[users[userid].walletAddress] = numSHGs;
        }
        shgsOfDistrict[_district].push(id);
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

    function sendGrant(uint256 _requestid) public {
        require(
            users[addressToUser[msg.sender]].userType == UserType.TREASURER,
            "Unauthorized reqest"
        );
        require(
            userRequests[_requestid].status == RequestStatus.APPROVED,
            "Unapproved request"
        );
        UserRequest storage request = userRequests[_requestid];

        request.status = RequestStatus.COMPLETED;

        Loan memory newLoan = Loan({
            loanId: ++numLoans,
            lenderId: request.SHGId,
            amount: request.amount,
            lendeeId: request.userId,
            intrest: shgs[request.SHGId].baseIntrest,
            loanTime: request.loanTime,
            date: block.timestamp,
            lastEMI: 0
        });

        loans[numLoans] = newLoan;
        shgs[request.SHGId].loansGiven.push(numLoans);
        users[request.userId].loansTaken.push(numLoans);

        require(shgs[request.SHGId].currentBalance >= request.amount);
        payable(users[request.userId].walletAddress).transfer(request.amount);
        shgs[request.SHGId].currentBalance -= request.amount;
    }

    function checkApproval(uint256 _requestid) internal view returns (bool) {
        uint256[] storage approvals = userRequests[_requestid].approvals;

        for (uint256 i = 0; i < approvals.length; i++) {
            if (approvals[i] == addressToUser[msg.sender]) {
                return false;
            }
        }

        return true;
    }

    function approveRequest(uint256 _requestid, uint256 _shgid)
        public
        onlySHG(_shgid)
    {
        UserRequest storage request = userRequests[_requestid];
        require(request.SHGId == _shgid);

        require(checkApproval(_requestid));
        request.approvals.push(addressToUser[msg.sender]);

        if (request.approvals.length > shgs[_shgid].users.length / 2) {
            request.status = RequestStatus.APPROVED;
        }
    }

    function sendRequestToBank(
        uint256 _shgid,
        uint256 _amount,
        uint256 _loanTime
    ) public onlySHG(_shgid) {
        require(users[addressToUser[msg.sender]].shgid == _shgid);
        uint256 reqid = numSHGRequests++;
        shgRequests[reqid] = SHGRequest(
            reqid,
            _shgid,
            _amount,
            _loanTime,
            RequestStatus.IN_PROCESS
        );
        shgs[_shgid].loansTaken.push(reqid);
    }

    function shgPayEMI(
        uint256 _shgid,
        uint256 _loanid,
        uint256 _amount
    ) public onlySHG(_shgid) {
        uint256 amount = getSHGEMI(_shgid, _loanid);
        require(amount == _amount);
        Loan storage loan = loans[_loanid];
        payable(address(this)).transfer(_amount);
        shgs[loan.lendeeId].currentBalance += _amount;
        loan.lastEMI = block.timestamp;
    }

    // fetch functions
    function getSHGEMI(uint256 _shgid, uint256 _loanid)
        public
        onlySHG(_shgid)
        returns (uint256)
    {
        Loan storage loan = loans[_loanid];
        uint256 months = ((block.timestamp - loan.lastEMI) / 24) * 60 * 60 * 30;

        require(months > 0);
        uint256 P = loan.amount;
        uint256 r = loan.intrest;
        uint256 t = loan.loanTime;
        uint256 emi = (P * (1 + ((r / 100) * 12))) ^ ((12 * t) - P);

        loan.amount = loan.amount - emi;
        return emi;
    }

    function getSHGMembers(uint256 shgid)
        public
        view
        returns (uint256[] memory)
    {
        return shgs[shgid].users;
    }
}

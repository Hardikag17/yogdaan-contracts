// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "./structs.sol";
import "./modifiers.sol";

contract User is structs, modifiers {
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
        uint256 _userid,
        uint256 _amount,
        string memory _description,
        uint256 _loanTime
    ) public {
        uint256 _requestId = ++numUserRequests;
        userRequests[_requestId] = UserRequest(
            _requestId,
            _userid,
            _amount,
            _description,
            _shgid,
            RequestStatus.IN_PROCESS,
            _loanTime,
            new uint256[](0)
        );
    }

    function deleteRequest(uint256 _userid, uint256 _requestid)
        public
        onlyUser(_userid)
    {
        require(userRequests[_requestid].userId == _userid);

        uint256 index;
        for (uint256 i = 0; i < numUserRequests; i++) {
            if (userRequests[i].userId == _userid) {
                index = i;
                break;
            }
        }
        delete userRequests[index];
    }

    // Repay functions for user

    function payEMI(
        uint256 _userid,
        uint256 _loanid,
        uint256 _amount
    ) public payable onlyUser(_userid) {
        uint256 amount = getUserEMI(_userid, _loanid);
        require(amount == _amount);
        Loan storage loan = loans[_loanid];
        payable(address(this)).transfer(_amount);
        shgs[loan.lendeeId].currentBalance += _amount;
        loan.lastEMI = block.timestamp;
    }

    // fetch functions

    function getUserEMI(uint256 userid, uint256 loanid)
        public
        onlyUser(userid)
        returns (uint256)
    {
        Loan storage loan = loans[loanid];
        uint256 months = ((block.timestamp - loan.lastEMI) / 24) * 60 * 60 * 30;

        require(months > 0);
        uint256 P = loan.amount;
        uint256 r = loan.intrest;
        uint256 t = loan.loanTime;
        uint256 emi = (P * (1 + ((r / 100) * 12))) ^ ((12 * t) - P);

        loan.amount = loan.amount - emi;
        return emi;
    }

    function getAllLoans(uint256 userid)
        public
        view
        onlyUser(userid)
        returns (uint256[] memory)
    {
        return users[userid].loansTaken;
    }

    function flagDefaulters() public {}
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "./structs.sol";
import "./modifiers.sol";

contract Bank is structs, modifiers {
    function addBank(
        string memory _name,
        address _walletAddress,
        string memory _code,
        uint256 _intrestRate
    ) public {
        uint256 id = ++numBanks;
        banks[id] = Bank(
            id,
            _name,
            _walletAddress,
            _code,
            _intrestRate,
            new uint256[](0)
        );

        addressToBankid[_walletAddress] = numBanks;
    }

    function approveLoan(uint256 _shgrequestid, uint256 _bankid)
        public
        onlyBank(_bankid)
    {
        shgRequests[_shgrequestid].status = RequestStatus.APPROVED;
    }

    function grantLoan(
        uint256 _shgrequestid,
        uint256 _bankid,
        uint256 _amount
    ) public onlyBank(_bankid) {
        payable(address(this)).transfer(_amount);
        shgRequests[_shgrequestid].status = RequestStatus.COMPLETED;
        shgs[shgRequests[_shgrequestid].shgid].currentBalance += _amount;
    }

    function shgLoan(
        uint256 _bankid,
        uint256 _requestid,
        uint256 _amount
    ) public payable onlyBank(_bankid) {
        Loan memory newLoan = Loan({
            loanId: ++numLoans,
            lenderId: shgRequests[_requestid].shgid,
            amount: _amount,
            lendeeId: _bankid,
            intrest: banks[_bankid].intrestRate,
            loanTime: shgRequests[_requestid].loanTime,
            date: block.timestamp,
            lastEMI: 0
        });

        shgs[shgRequests[_requestid].shgid].loansTaken.push(numLoans);

        payable(address(this)).transfer(_amount);
        shgs[shgRequests[_requestid].shgid].currentBalance += _amount;
        loans[numLoans] = newLoan;
    }
}

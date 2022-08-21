// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract structs {
    enum UserType {
        PRESIDENT,
        VICE_PRESIDENT,
        TREASURER,
        MEMBER,
        NONE,
        ADMIN
    }

    enum Gender {
        MALE,
        FEMALE,
        OTHER
    }

    enum RequestStatus {
        APPROVED,
        COMPLETED,
        REJECTED,
        IN_PROCESS
    }

    struct User {
        uint256 id;
        string name;
        string aadhar;
        uint256 mobno;
        string fatherName;
        address walletAddress;
        uint256[] loansTaken;
        uint256 amountTaken;
        uint256 shgid;
        UserType userType;
        Gender gender;
    }

    struct Location {
        string state;
        string district;
        string blockName;
        string panchyarName;
        string villageName;
    }

    struct Bank {
        uint256 id;
        string name;
        address walletAddress;
        string code;
        uint256 intrestRate;
        uint256[] requests;
    }

    struct SHG {
        uint256 id;
        uint256[] users;
        string name;
        Location location;
        string dateOfFormation;
        uint256 currentBalance;
        uint256 owedBalance;
        uint256[] loansGiven;
        uint256[] loansTaken;
        uint256 baseIntrest;
    }

    struct Loan {
        uint256 loanId;
        uint256 lenderId;
        uint256 amount;
        uint256 lendeeId;
        uint256 intrest;
        uint256 loanTime;
        uint256 date;
        uint256 lastEMI;
    }

    struct Status {
        RequestStatus requestStatus;
        uint256 Id;
    }

    struct UserRequest {
        uint256 requestId;
        uint256 userId;
        uint256 amount;
        string description;
        uint256 SHGId;
        RequestStatus status;
        uint256 loanTime;
        uint256[] approvals;
    }

    struct SHGRequest {
        uint256 requestid;
        uint256 shgid;
        uint256 amount;
        uint256 loanTime;
        RequestStatus status;
    }

    mapping(uint256 => User) users;
    mapping(uint256 => SHG) public shgs;
    mapping(uint256 => Bank) banks;

    mapping(address => uint256) addressToUser;
    mapping(uint256 => Loan) loans;
    mapping(uint256 => UserRequest) userRequests;
    mapping(uint256 => SHGRequest) shgRequests;

    uint256 numUsers;
    uint256 numSHGs;
    uint256 numUserRequests;
    uint256 numSHGRequests;
    uint256 numBanks;
    uint256 numLoans;
}

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
        IN_PROCESS,
        FORWARDED
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
        string name;
        address walletAddress;
        string code;
        uint256 intrestRate;
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
    }

    struct Loan {
        uint256 loanId;
        uint256 lenderId;
        uint256 amount;
        uint256 lendeeId;
        uint256 intrest;
        uint256 date;
        uint256 lastEMI;
    }

    struct Status {
        RequestStatus requestStatus;
        uint256 Id;
    }

    struct Request {
        uint256 requestId;
        uint256 userId;
        uint256 amount;
        string description;
        uint256 SHGId;
        Status[] status;
    }
}

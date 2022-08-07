// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract Yogdaan {
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

    struct request {
        uint256 requestId;
        uint256 userId;
        uint256 amount;
        string description;
        uint256 SHGId;
        Status[] status;
    }

    mapping(uint256 => User) users;
    mapping(address => uint256) addressToUser;
    mapping(uint256 => Loan) loans;
    uint256 numUsers;

    function login() public view returns (bool) {
        return (users[addressToUser[msg.sender]].walletAddress == msg.sender);
    }

    function addUser(
        string memory name,
        string memory aadhar,
        uint256 mobno,
        string memory fatherName,
        address walletAddress,
        uint256[] memory loansTaken,
        uint256 amountTaken,
        UserType userType,
        Gender gender
    ) public {
        require(
            users[addressToUser[msg.sender]].walletAddress != msg.sender,
            "Already Registered"
        );
        users[addressToUser[msg.sender]] = User(
            numUsers++,
            name,
            aadhar,
            mobno,
            fatherName,
            walletAddress,
            loansTaken,
            amountTaken,
            userType,
            gender
        );
    }

    // function addSHG(
    //     uint256[] memory user,
    //     uint256 president,

    //     string name,
    //     Location location,
    //     string dateOfFormation,
    //     uint256 currentBalance,
    //     uint256 owedBalance,
    //     uint256[] loansGiven,
    //     uint256[] loansTaken
    // ) public {}
}

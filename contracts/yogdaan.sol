// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "./lib/structs.sol";

contract Yogdaan is structs {
    function addBank() public {}

    function addSHGMember() public {}

    function removeSHGMember() public {}

    function updateMemberRole() public {}

    function makeRequest() public {}

    function approveRequest() public {}

    function sendGrant() public {}

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

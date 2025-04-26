// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EmployerRegistry {
    struct Employer {
        string employerId;
        string name;
        bytes32 passwordHash;
        bool isApproved;
    }

    mapping(string => Employer) public employers;
    string[] public registeredEmployers;
    address public admin;

    event EmployerRegistered(string employerId, string name);
    event EmployerApproved(string employerId);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    function registerEmployer(string memory _employerId, string memory _name, bytes32 _passwordHash) public {
        require(employers[_employerId].passwordHash == bytes32(0), "Employer ID already exists");
        
        employers[_employerId] = Employer({
            employerId: _employerId,
            name: _name,
            passwordHash: _passwordHash,
            isApproved: true  // Automatically approve employers
        });

        registeredEmployers.push(_employerId);
        emit EmployerRegistered(_employerId, _name);
        emit EmployerApproved(_employerId);
    }

    function approveEmployer(string memory _employerId) public onlyAdmin {
        require(employers[_employerId].passwordHash != bytes32(0), "Employer does not exist");
        require(!employers[_employerId].isApproved, "Employer is already approved");
        
        employers[_employerId].isApproved = true;
        emit EmployerApproved(_employerId);
    }

    function loginEmployer(string memory _employerId, bytes32 _passwordHash) public view returns (bool) {
        require(employers[_employerId].passwordHash != bytes32(0), "Employer does not exist");
        require(employers[_employerId].isApproved, "Employer is not approved");
        
        return employers[_employerId].passwordHash == _passwordHash;
    }

    function getRegisteredEmployers() public view returns (string[] memory) {
        return registeredEmployers;
    }

    function getEmployerDetails(string memory _employerId) public view returns (string memory name, bool isApproved) {
        require(employers[_employerId].passwordHash != bytes32(0), "Employer does not exist");
        return (employers[_employerId].name, employers[_employerId].isApproved);
    }
} 
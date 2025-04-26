// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InstitutionRegistry {
    struct Institution {
        string institutionId;
        string name;
        string passwordHash;
        bool isRegistered;
        bool isApproved;
    }

    mapping(string => Institution) public institutions;
    string[] public registeredInstitutionIds;
    
    event InstitutionRegistered(string institutionId);
    event InstitutionApproved(string institutionId);
    event InstitutionLoggedIn(string institutionId);

    function registerInstitution(
        string memory _institutionId,
        string memory _name,
        string memory _passwordHash
    ) public {
        require(!institutions[_institutionId].isRegistered, "Institution already registered");
        
        institutions[_institutionId] = Institution({
            institutionId: _institutionId,
            name: _name,
            passwordHash: _passwordHash,
            isRegistered: true,
            isApproved: true
        });

        registeredInstitutionIds.push(_institutionId);
        emit InstitutionRegistered(_institutionId);
        emit InstitutionApproved(_institutionId);
    }

    function loginInstitution(
        string memory _institutionId,
        string memory _passwordHash
    ) public returns (bool) {
        require(institutions[_institutionId].isRegistered, "Institution not registered");
        require(
            keccak256(bytes(institutions[_institutionId].passwordHash)) == keccak256(bytes(_passwordHash)),
            "Invalid password"
        );

        emit InstitutionLoggedIn(_institutionId);
        return true;
    }

    function isInstitutionRegistered(string memory _institutionId) public view returns (bool) {
        return institutions[_institutionId].isRegistered;
    }

    function isInstitutionApproved(string memory _institutionId) public view returns (bool) {
        return institutions[_institutionId].isApproved;
    }

    function getRegisteredInstitutions() public view returns (string[] memory) {
        return registeredInstitutionIds;
    }

    function getInstitutionDetails(string memory _institutionId) public view returns (
        string memory name,
        bool isApproved
    ) {
        require(institutions[_institutionId].isRegistered, "Institution not registered");
        return (
            institutions[_institutionId].name,
            institutions[_institutionId].isApproved
        );
    }
} 
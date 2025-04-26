// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StudentRegistry {
    struct Student {
        string studentId;
        string passwordHash;
        bool isRegistered;
    }

    mapping(string => Student) public students;
    event StudentRegistered(string studentId);
    event StudentLoggedIn(string studentId);

    function registerStudent(string memory _studentId, string memory _passwordHash) public {
        require(!students[_studentId].isRegistered, "Student already registered");
        
        students[_studentId] = Student({
            studentId: _studentId,
            passwordHash: _passwordHash,
            isRegistered: true
        });

        emit StudentRegistered(_studentId);
    }

    function loginStudent(string memory _studentId, string memory _passwordHash) public returns (bool) {
        require(students[_studentId].isRegistered, "Student not registered");
        require(keccak256(bytes(students[_studentId].passwordHash)) == keccak256(bytes(_passwordHash)), "Invalid password");

        emit StudentLoggedIn(_studentId);
        return true;
    }

    function isStudentRegistered(string memory _studentId) public view returns (bool) {
        return students[_studentId].isRegistered;
    }
} 
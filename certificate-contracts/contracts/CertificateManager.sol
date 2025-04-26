// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CertificateManager {
    struct Certificate {
        string certificateId;
        string studentId;
        string institutionId;
        string certificateHash;
        uint256 issueDate;
        uint256 expiryDate;
        bool isValid;
    }

    mapping(string => Certificate) public certificates;
    mapping(string => string[]) public studentCertificates;
    event CertificateIssued(string certificateId, string studentId, string institutionId);
    event CertificateVerified(string certificateId, bool isValid);

    function issueCertificate(
        string memory _certificateId,
        string memory _studentId,
        string memory _institutionId,
        string memory _certificateHash,
        uint256 _issueDate,
        uint256 _expiryDate
    ) public {
        require(certificates[_certificateId].issueDate == 0, "Certificate ID already exists");
        
        certificates[_certificateId] = Certificate({
            certificateId: _certificateId,
            studentId: _studentId,
            institutionId: _institutionId,
            certificateHash: _certificateHash,
            issueDate: _issueDate,
            expiryDate: _expiryDate,
            isValid: true
        });

        studentCertificates[_studentId].push(_certificateId);
        emit CertificateIssued(_certificateId, _studentId, _institutionId);
    }

    function verifyCertificate(string memory _certificateId, string memory _certificateHash) public returns (bool) {
        require(certificates[_certificateId].issueDate != 0, "Certificate does not exist");
        require(certificates[_certificateId].isValid, "Certificate is invalid");
        require(block.timestamp <= certificates[_certificateId].expiryDate, "Certificate has expired");
        
        bool isValid = keccak256(bytes(certificates[_certificateId].certificateHash)) == keccak256(bytes(_certificateHash));
        emit CertificateVerified(_certificateId, isValid);
        return isValid;
    }

    function getStudentCertificates(string memory _studentId) public view returns (string[] memory) {
        return studentCertificates[_studentId];
    }

    function getCertificateDetails(string memory _certificateId) public view returns (
        string memory studentId,
        string memory institutionId,
        uint256 issueDate,
        uint256 expiryDate,
        bool isValid
    ) {
        Certificate memory cert = certificates[_certificateId];
        return (cert.studentId, cert.institutionId, cert.issueDate, cert.expiryDate, cert.isValid);
    }
} 
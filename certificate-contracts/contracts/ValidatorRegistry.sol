// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ValidatorRegistry {
    struct Validator {
        string validatorId;
        string passwordHash;
        bool isRegistered;
    }

    mapping(string => Validator) public validators;
    event ValidatorRegistered(string validatorId);
    event ValidatorLoggedIn(string validatorId);

    constructor() {
        // Register the default validator (ID: 1, Password: 1)
        string memory defaultId = "1";
        string memory defaultPasswordHash = "6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b"; // hash of "1"
        
        validators[defaultId] = Validator({
            validatorId: defaultId,
            passwordHash: defaultPasswordHash,
            isRegistered: true
        });

        emit ValidatorRegistered(defaultId);
    }

    function registerValidator(string memory _validatorId, string memory _passwordHash) public {
        require(!validators[_validatorId].isRegistered, "Validator already registered");
        
        validators[_validatorId] = Validator({
            validatorId: _validatorId,
            passwordHash: _passwordHash,
            isRegistered: true
        });

        emit ValidatorRegistered(_validatorId);
    }

    function loginValidator(string memory _validatorId, string memory _passwordHash) public returns (bool) {
        require(validators[_validatorId].isRegistered, "Validator not registered");
        require(
            keccak256(bytes(validators[_validatorId].passwordHash)) == keccak256(bytes(_passwordHash)),
            "Invalid password"
        );

        emit ValidatorLoggedIn(_validatorId);
        return true;
    }

    function isValidatorRegistered(string memory _validatorId) public view returns (bool) {
        return validators[_validatorId].isRegistered;
    }
} 
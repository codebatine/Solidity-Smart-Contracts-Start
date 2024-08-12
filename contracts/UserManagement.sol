// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract UserManagement {
    struct User {
        string name;
        uint8 age;
    }

    mapping(address => User) public user;

    function setUserProfile(string memory _name, uint8 _age) public {
        user[msg.sender] = User(_name, _age);
    }
}
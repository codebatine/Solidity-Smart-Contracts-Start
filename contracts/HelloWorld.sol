// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract HelloWorld {
    // State variable
    string public message = "1st contract";

    // Write function with local variable
    function setMessage(string memory _newMessage) public {
        message = _newMessage;
    }

    // Not needed in the actual contract
    // Read functions - reading from blockchain
    /* function getMessage() public view returns(string memory) {
        return message;
    } */
}
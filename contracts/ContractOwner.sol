// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract ContractOwner {
    // Deployer = Owner = Deployer address
    address public owner = msg.sender;

    function updateOwner(address _newOwner) public {
        require(msg.sender == owner, "Only the current owner can change the ownership.");
        owner= _newOwner;
    }
}
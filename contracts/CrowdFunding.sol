// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Crowdfunding {
    address public owner;
    uint public goal;
    uint public deadline;
    bool public goalReached;
    uint public currentBalance;
    mapping(address => uint) public contributors;

    constructor(uint _goal, uint _duration) {
        owner = msg.sender;
        goal = _goal;
        deadline = block.timestamp + _duration;
        goalReached = false;
    }

    function contribute() public payable {
        require(block.timestamp < deadline, "Deadline passed.");
        //msg.sender = the one who calls the contract
        //msg.value = how much the user sent when the function is called
        contributors[msg.sender] += msg.value;
        currentBalance += msg.value;
        if (currentBalance >= goal) {
            goalReached = true;
        }
    }

    function withdrawFund() public {
        if (goalReached) {
            require(
                msg.sender == owner,
                "Only the owner can withdraw the funds."
            );
            uint _amountToTransfer = currentBalance;
            currentBalance = 0;
            payable(owner).transfer(_amountToTransfer);
        } else {
            uint _amount = contributors[msg.sender];
            contributors[msg.sender] = 0;
            currentBalance -= _amount;
            payable(msg.sender).transfer(_amount);
        }
    }
}

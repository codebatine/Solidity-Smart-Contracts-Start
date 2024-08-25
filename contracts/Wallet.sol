// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Wallet {
    uint public contractBalance;
    bool private locked;
    mapping(address => uint) internal balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        contractBalance += msg.value;

        assert(contractBalance == address(this).balance);
    }
}

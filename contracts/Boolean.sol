// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Boolean {
    bool public isActive = false;

    function  setState(bool _state) public {
        isActive = _state;
    }
}
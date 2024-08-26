// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

library MathLibrary {
    function add(uint a, uint b) internal pure returns (uint) {
        return a + b;
    }

    function subtract(uint a, uint b) internal pure returns (uint) {
        return a - b;
    }

    function multiply(uint a, uint b) internal pure returns (uint) {
        return a * b;
    }
}

contract Calculator {
    using MathLibrary for uint;

    function add(uint a, uint b) public pure returns (uint) {
        //return MathLibrary.add(a, b);
        return a.add(b);
    }

    function subtract(uint a, uint b) public pure returns (uint) {
        return a.subtract(b);
    }

    function multiply(uint a, uint b) public pure returns (uint) {
        return a.multiply(b);
    }
}

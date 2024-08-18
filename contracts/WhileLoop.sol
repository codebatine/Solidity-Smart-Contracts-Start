// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract WhileLoop {
    uint[] internal numbers;

    function addNumber(uint _number) public {
        numbers.push(_number);
    }

    function sumNumber() public view returns (uint) {
        uint _sum = 0;
        uint i = 0;

        while (i < numbers.length) {
            _sum += numbers[i];
            i++;
        }

        return _sum;
    }
}

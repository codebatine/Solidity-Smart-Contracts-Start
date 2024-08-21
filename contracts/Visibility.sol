// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Visibility {
    // Public functions can be called internally and externally
    function publicFunction() public pure returns (string memory) {
        return "This is a public function.";
    }

    // Can only be called internally
    function internalFunction() internal pure returns (string memory) {
        return "This is an internal function.";
    }

    // Can only be called internally och can't be inherited
    function privateFunction() private pure returns (string memory) {
        return "This is a private function.";
    }

    // Can only be called externally
    function externalFunction() external pure returns (string memory) {
        return "This is an external function.";
    }

    // Public function that calls the internal function
    function callInternalFunction() public pure returns (string memory) {
        return internalFunction();
    }

    function callPrivateFunction() public pure returns (string memory) {
        return privateFunction();
    }

    function callExternalFunction() public view returns (string memory) {
        return this.externalFunction();
    }
}

// Explain inheritence
contract VisibilityChild is Visibility {
    function callParentInternalFunction() public pure returns (string memory) {
        return internalFunction();
    }

    //Demo purpose for no access
    // function callParentPrivateFunction() public pure returns(string memory) {
    //   return privateFunction();
    // }
}

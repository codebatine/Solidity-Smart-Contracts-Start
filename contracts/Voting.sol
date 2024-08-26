// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Voting {
    enum VotingState {
        NotStarted,
        Ongoing,
        Finished
    }

    struct Candidate {
        string name;
        uint voteCount;
    }

    Candidate[] public candidates;
    VotingState public votingState;
    mapping(address => bool) public hasVoted;
    string public winner;

    constructor(string[] memory _votingOptions) {
        for (uint i = 0; i < _votingOptions.length; i++) {
            candidates.push(Candidate({name: _votingOptions[i], voteCount: 0}));
        }
        votingState = VotingState.NotStarted;
        winner = "";
    }

    modifier inState(VotingState _state) {
        require(
            votingState == _state,
            "Invalid state, you can't perform this action."
        );
        _;
    }

    function startVoting() public inState(VotingState.NotStarted) {
        votingState = VotingState.Ongoing;
    }

    function vote(
        string memory _votingOption
    ) public inState(VotingState.Ongoing) {
        require(!hasVoted[msg.sender], "You've already voted.");

        bool _found = false;
        for (uint i = 0; i < candidates.length; i++) {
            if (
                keccak256(bytes(candidates[i].name)) ==
                keccak256(bytes(_votingOption))
            ) {
                candidates[i].voteCount += 1;
                _found = true;
                if (candidates[i].voteCount == 5) {
                    votingState = VotingState.Finished;
                    winner = candidates[i].name;
                }
                break;
            }
        }
        require(_found, "Name not found.");
        hasVoted[msg.sender] = true;
    }
}

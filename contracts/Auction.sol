// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Auction {
    struct Bid {
        address bidder;
        uint amount;
    }

    Bid[] public bids;
    uint public minimumBid;

    constructor(uint _minimumBid) {
        minimumBid = _minimumBid;
    }

    function placeBid() public payable {
        require(msg.value > 0, "Bid amount must be more than 0.");
        bids.push(Bid({bidder: msg.sender, amount: msg.value}));
    }

    function calculateAverageBidAboveMinimum()
        public
        view
        returns (uint _average)
    {
        uint i = 0;
        uint _total = 0;
        uint _count = 0;

        if (bids.length == 0) {
            return 0;
        }

        do {
            if (bids[i].amount >= minimumBid) {
                _total += bids[i].amount;
                _count++;
            }
            i++;
        } while (i < bids.length);

        _average = _total / _count;

        return _average;
    }
}

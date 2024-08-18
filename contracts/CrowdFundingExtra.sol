// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract AuctionHouse {
    struct Item {
        address owner;
        string name;
        bool isAuctioned;
    }

    struct Auction {
        uint itemId;
        uint minPrice;
        uint highestBid;
        address highestBidder;
        uint deadline;
        bool ended;
    }

    address public owner;
    uint public itemCount;
    mapping(uint => Item) public items;
    mapping(uint => Auction) public auctions;
    mapping(uint => mapping(address => uint)) public bids; // Tracks bids for each item by users

    modifier onlyOwner(uint itemId) {
        require(
            msg.sender == items[itemId].owner,
            "Only the owner can perform this action."
        );
        _;
    }

    modifier auctionExists(uint itemId) {
        require(items[itemId].isAuctioned, "Item is not up for auction.");
        _;
    }

    constructor() {
        owner = msg.sender;
        itemCount = 0;
    }

    function addItem(string memory _name) public {
        itemCount++;
        items[itemCount] = Item({
            owner: msg.sender,
            name: _name,
            isAuctioned: false
        });
    }

    function startAuction(
        uint itemId,
        uint _minPrice,
        uint _duration
    ) public onlyOwner(itemId) {
        require(
            !items[itemId].isAuctioned,
            "Auction already started for this item."
        );

        items[itemId].isAuctioned = true;

        auctions[itemId] = Auction({
            itemId: itemId,
            minPrice: _minPrice,
            highestBid: 0,
            highestBidder: address(0),
            deadline: block.timestamp + _duration,
            ended: false
        });
    }

    function bid(uint itemId) public payable auctionExists(itemId) {
        Auction storage auction = auctions[itemId];

        require(block.timestamp < auction.deadline, "Auction has ended.");
        require(
            msg.sender != items[itemId].owner,
            "Owner cannot bid on their own item."
        );
        require(
            msg.value > auction.minPrice && msg.value > auction.highestBid,
            "Bid must be higher than current highest bid."
        );

        // Refund the previous highest bidder
        if (auction.highestBidder != address(0)) {
            bids[itemId][auction.highestBidder] = 0; // Reset previous highest bid
            payable(auction.highestBidder).transfer(auction.highestBid);
        }

        // Update the highest bid and bidder
        auction.highestBid = msg.value;
        auction.highestBidder = msg.sender;
        bids[itemId][msg.sender] = msg.value;
    }

    function endAuction(
        uint itemId
    ) public onlyOwner(itemId) auctionExists(itemId) {
        Auction storage auction = auctions[itemId];

        require(
            block.timestamp >= auction.deadline,
            "Auction is still ongoing."
        );
        require(!auction.ended, "Auction already ended.");

        auction.ended = true;

        if (auction.highestBidder != address(0)) {
            // Transfer the highest bid to the item owner
            payable(items[itemId].owner).transfer(auction.highestBid);
        }

        items[itemId].isAuctioned = false; // Mark the item as no longer auctioned
    }

    function getHighestBid(
        uint itemId
    ) public view auctionExists(itemId) returns (uint, address) {
        Auction storage auction = auctions[itemId];
        return (auction.highestBid, auction.highestBidder);
    }
}

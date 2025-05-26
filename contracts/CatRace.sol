// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract CatRace {
    struct Cat {
        address owner;
        uint256 bet;
        bool isWinner;
    }

    Cat[] public cats;
    address public owner;
    bool public raceStarted;
    uint256 public totalBet;
    uint256 public winnerIndex;

    constructor() {
        owner = msg.sender;
    }

    function enterRace() public payable {
        require(!raceStarted, "Race already started");
        require(msg.value > 0, "Must place a bet");

        cats.push(Cat(msg.sender, msg.value, false));
        totalBet += msg.value;
    }

    function startRace() public {
        require(msg.sender == owner, "Only owner can start the race");
        require(!raceStarted, "Race already started");
        require(cats.length >= 2, "Not enough cats");

        raceStarted = true;
        winnerIndex = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % cats.length;
        cats[winnerIndex].isWinner = true;

        payable(cats[winnerIndex].owner).transfer(totalBet);
    }

    function getCats() public view returns (Cat[] memory) {
        return cats;
    }

    function resetRace() public {
        require(msg.sender == owner, "Only owner can reset");
        delete cats;
        raceStarted = false;
        totalBet = 0;
        winnerIndex = 0;
    }
}
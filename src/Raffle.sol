// Layout of the contract file:
// version
// imports
// errors
// interfaces, libraries, contract

// Inside Contract:
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private

// view & pure functions


// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

/**
 * @title A simple raffle contract
 * @author @Hexon Zhang
 * @notice This contract is for creating a simple raffle
 * @dev This implements the Chainlink VRFv2.5 and Chainlink Automation
 */
contract Raffle {
    /* Errors */
    error Raffle__SendMoreToEnterRaffle();

    uint256 private immutable i_entranceFee;

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() external payable{
        // require(msg.value > i_entranceFee, "Not enough ETH sent");
        // require(msg.value > i_entranceFee, SendMoreToEnterRaffle());
        if (msg.value < i_entranceFee) {
            revert Raffle__SendMoreToEnterRaffle();
        }
    }

    function pickWinner() public {

    }

    /** Getter functions */

    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
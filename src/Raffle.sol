// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

/**
 * @title A simple raffle contract
 * @author @Hexon Zhang
 * @notice This contract is for creating a simple raffle
 * @dev This implements the Chainlink VRFv2.5 and Chainlink Automation
 */
contract Raffle {
    uint256 private immutable i_entranceFee;

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() public payable{

    }

    function pickWinner() public {

    }

    /** Getter functions */

    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
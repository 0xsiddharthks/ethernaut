// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vault {
    bool public locked;

    // Marking a variable as private only prevents other contracts from accessing it directly.
    // However, any private state variable / local variable can still be publically decoded.

    // to ensure data is private, the only way is to encrypto before putting it into the blockchain, and never put the key on chain. other option is to use zk-snark.
    bytes32 private password;

    constructor(bytes32 _password) {
        locked = true;
        password = _password;
    }

    function unlock(bytes32 _password) public {
        if (password == _password) {
            locked = false;
        }
    }
}

/**
AIM:
- unlock the vault

check the deploymenttx on tenderly and find the password there

forge build ./src/Vault.sol
cast run $TX_HASH --rpc-url $OP_SEP_RPC --quick -v
cast send $INSTANCE "unlock(bytes32)()" $(cast format-bytes32-string $PASSWORD) --rpc-url $OP_SEP_RPC --private-key $WALLET_PK
*/

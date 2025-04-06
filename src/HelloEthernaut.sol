// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Instance {
    // keeping the state variable public creates a getter function with the same name.
    string public password;
    uint8 public infoNum = 42;
    string public theMethodName = "The method name is method7123949.";
    bool private cleared = false;

    // constructor
    constructor(string memory _password) {
        password = _password;
    }

    function info() public pure returns (string memory) {
        return "You will find what you need in info1().";
    }

    function info1() public pure returns (string memory) {
        return 'Try info2(), but with "hello" as a parameter.';
    }

    // Different storage options for params / return values:
    // - memory: temporary storage that only exists during the function execution. cleared after function retuns.
    // - storage: permanent storage.
    // - calldata: gas efficient read-only storage (for external functions).
    function info2(string memory param) public pure returns (string memory) {
        if (
            keccak256(abi.encodePacked(param)) ==
            keccak256(abi.encodePacked("hello"))
        ) {
            return
                "The property infoNum holds the number of the next info method to call.";
        }
        return "Wrong parameter.";
    }

    function info42() public pure returns (string memory) {
        return "theMethodName is the name of the next method.";
    }

    function method7123949() public pure returns (string memory) {
        return "If you know the password, submit it to authenticate().";
    }

    function authenticate(string memory passkey) public {
        if (
            keccak256(abi.encodePacked(passkey)) ==
            keccak256(abi.encodePacked(password))
        ) {
            cleared = true;
        }
    }

    function getCleared() public view returns (bool) {
        return cleared;
    }
}

/**
Notes on forge cast:

methods used:
cast call : for view functions
    - cast call $ADDRESS $FUNCTION_SIGNATURE --rpc-url $RPC (--from $FROM_ADDRESS)
cast send : for sending transactions
    - cast send $ADDRESS $TX_DATA --rpc-url $RPC --private-key $PRIVATE_KEY
cast calldata : for encoding input params
    - cast calldata $FUNCTION_SIGNATURE $PARAMETERS
cast decode-abi : for decoding input / output (default) calldata`
    - cast decode-abi (--input) $FUNCTION_SIGNATURE $CALLDATA
cast decode-calldata : for decoding input calldata
    - cast decode-calldata $FUNCTION_SIGNATURE $CALLDATA
 */

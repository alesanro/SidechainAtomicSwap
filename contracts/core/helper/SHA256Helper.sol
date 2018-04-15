pragma solidity ^0.4.21;

contract SHA256Helper {
    function calc_sha256(bytes _message) pure external returns (bytes32) {
        return sha256(_message);
    }
}

/**
 * Copyright 2017–2018, LaborX PTY
 * Licensed under the AGPL Version 3 license.
 */

pragma solidity ^0.4.21;


import "../event/MultiEventsHistoryAdapter.sol";


/// @title ChronoBank Platform Emitter.
///
/// Contains all the original event emitting function definitions and events.
/// In case of new events needed later, additional emitters can be developed.
/// All the functions is meant to be called using delegatecall.
contract ChronoBankPlatformEmitter is MultiEventsHistoryAdapter {

    event Transfer(address indexed from, address indexed to, bytes32 indexed symbol, uint value, string reference);
    event Issue(bytes32 indexed symbol, uint value, address indexed by);
    event Revoke(bytes32 indexed symbol, uint value, address indexed by);
    event OwnershipChange(address indexed from, address indexed to, bytes32 indexed symbol);
    event Approve(address indexed from, address indexed spender, bytes32 indexed symbol, uint value);
    event Recovery(address indexed from, address indexed to, address by);
    event Error(uint errorCode);

    function emitTransfer(address _from, address _to, bytes32 _symbol, uint _value, string _reference) public {
        emit Transfer(_from, _to, _symbol, _value, _reference);
    }

    function emitIssue(bytes32 _symbol, uint _value, address _by) public {
        emit Issue(_symbol, _value, _by);
    }

    function emitRevoke(bytes32 _symbol, uint _value, address _by) public {
        emit Revoke(_symbol, _value, _by);
    }

    function emitOwnershipChange(address _from, address _to, bytes32 _symbol) public {
        emit OwnershipChange(_from, _to, _symbol);
    }

    function emitApprove(address _from, address _spender, bytes32 _symbol, uint _value) public {
        emit Approve(_from, _spender, _symbol, _value);
    }

    function emitRecovery(address _from, address _to, address _by) public {
        emit Recovery(_from, _to, _by);
    }

    function emitError(uint _errorCode) public {
        emit Error(_errorCode);
    }
}
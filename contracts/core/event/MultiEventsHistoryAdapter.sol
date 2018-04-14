/**
 * Copyright 2017–2018, LaborX PTY
 * Licensed under the AGPL Version 3 license.
 */

pragma solidity ^0.4.11;

/**
 * @title General MultiEventsHistory user.
 *
 */
contract MultiEventsHistoryAdapter {

    /**
    *   @dev It is address of MultiEventsHistory caller assuming we are inside of delegate call.
    */
    function _self() internal view returns (address) {
        return msg.sender;
    }
}

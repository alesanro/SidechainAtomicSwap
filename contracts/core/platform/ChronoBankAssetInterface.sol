/**
 * Copyright 2017–2018, LaborX PTY
 * Licensed under the AGPL Version 3 license.
 */

pragma solidity ^0.4.21;


contract ChronoBankAssetInterface {
    function __transferWithReference(address _to, uint _value, string _reference, address _sender) public returns (bool);
    function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns (bool);
    function __approve(address _spender, uint _value, address _sender) public returns(bool);
    function __process(bytes /*_data*/, address /*_sender*/) public payable {
        revert();
    }
}

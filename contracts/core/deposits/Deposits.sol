/**
 * Copyright 2017–2018, LaborX PTY
 * Licensed under the AGPL Version 3 license.
 */

pragma solidity ^0.4.21;


import "../erc20/ERC20Interface.sol";
import "../common/Object.sol";
import "../event/MultiEventsHistoryAdapter.sol";

/// @title Supposed to be a token holder for cross-chain operations with tokens
/// Users usually should lock their token balance in this contract and request 
/// a middleware on a target sidechain to provide their currency.
/// To get users' tokens back users should request middleware to withdraw their
/// balance and send them to AtomicSwap contract
contract Deposits is Object, MultiEventsHistoryAdapter {
	
	uint constant DEPOSITS_SCOPE = 34000;
	uint constant DEPOSITS_NOT_ENOUGH_ALLOWANCE = DEPOSITS_SCOPE + 1;
	uint constant DEPOSITS_NOT_ENOUGH_BALANCE = DEPOSITS_SCOPE + 2;
	uint constant DEPOSITS_CANNOT_LOCK_TOKENS = DEPOSITS_SCOPE + 3;
	uint constant DEPOSITS_CANNOT_WITHDRAW_TOKENS = DEPOSITS_SCOPE + 4;

	event Locked(address indexed self, address indexed account, uint256 amount, address token);
	event Withdrawn(address indexed self, address indexed account, uint256 amount, address token);
	event Error(address indexed self, uint errorCode);

	mapping(address => bool) public oracles;
	address public eventsHistory;

	/// @dev Allow access only for oracle
    modifier onlyOracle {
        if (oracles[msg.sender]) {
            _;
        }
    }

	function Deposits() public {
		eventsHistory = address(this);
	}

	function setupEventsHistory(address _eventsHistory) onlyContractOwner external returns (uint) {
		eventsHistory = (_eventsHistory != 0x0) ? _eventsHistory : address(this);
		return OK;
	}

	/// @notice Adds oracle to whitelist
    /// @param _oracle an account address that will manage withdrawing operations
    function addOracles(address _oracle) onlyContractOwner external returns (uint) {
        require(_oracle != 0x0);

		oracles[_oracle] = true;
        return OK;
    }

    /// @notice Removes oracle from whitelist
    /// @param _oracle an account address that will be blacklisted from withdrawing operations
    function removeOracles(address _oracle) onlyContractOwner external returns (uint) {
        delete oracles[_oracle];
        return OK;
    }

	/// @notice Locks users' token balances to provide an opportunity to use sidechains.
	/// Usually users send tokens to Deposits balance and then receive equivalent number 
	/// of tokens in a sidechain network.
	/// Locking amount of tokens should be at first approved by user for withdrawings.
	/// @param _amount amount of tokens that will be locked
	/// @param _token ERC20 token address
	function lockToken(uint256 _amount, address _token) external returns (uint) {
		require(_token != 0x0);
		
		if (ERC20Interface(_token).allowance(msg.sender, address(this)) < _amount) {
			return _emitError(DEPOSITS_NOT_ENOUGH_ALLOWANCE);
		}

		if (!ERC20Interface(_token).transferFrom(msg.sender, address(this), _amount)) {
			return _emitError(DEPOSITS_CANNOT_LOCK_TOKENS);
		}

		_emitLocked(msg.sender, _amount, _token);
		return OK;
	}

	/// @notice Opposite to 'lockToken' function, starts a procedure of returning tokens that were locked.
	/// Should be performed by one of authorized oracles; then token balance will be transfered to oracle's
	/// account and proceeded for the next actions (as transferred to AtomicSwap contract).
	/// @param _to the final destination for tokens (a user)
	/// @param _amount amount of tokens to withdraw
	/// @param _token ERC20 token address
	function withdrawToken(address _to, uint256 _amount, address _token) onlyOracle external returns (uint) {
		require(_to != 0x0);
		require(_amount != 0);
		require(_token != 0x0);

		if (ERC20Interface(_token).balanceOf(address(this)) < _amount) {
			return _emitError(DEPOSITS_NOT_ENOUGH_BALANCE);
		}

		if (!ERC20Interface(_token).transfer(msg.sender, _amount)) {
			return _emitError(DEPOSITS_CANNOT_WITHDRAW_TOKENS);
		}

		_emitWithdrawn(_to, _amount, _token);
		return OK;
	}

	function emitLocked(address _account, uint256 _amount, address _token) public {
		emit Locked(_self(), _account, _amount, _token);
	}

	function emitWithdrawn(address _account, uint256 _amount, address _token) public {
		emit Withdrawn(_self(), _account, _amount, _token);
	}

	function emitError(uint _errorCode) public {
		emit Error(_self(), _errorCode);
	}

	function _emitLocked(address _account, uint256 _amount, address _token) private {
		Deposits(eventsHistory).emitLocked(_account, _amount, _token);
	}

	function _emitWithdrawn(address _account, uint256 _amount, address _token) private {
		Deposits(eventsHistory).emitWithdrawn(_account, _amount, _token);
	}

	function _emitError(uint _errorCode) private returns (uint) {
		Deposits(eventsHistory).emitError(_errorCode);
		return _errorCode;
	}
}
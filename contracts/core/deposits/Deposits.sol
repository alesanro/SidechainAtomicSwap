pragma solidity ^0.4.21;


import "../erc20/ERC20Interface.sol";
import "../common/Object.sol";
import "../event/MultiEventsHistoryAdapter.sol";


contract Deposits is Object, MultiEventsHistoryAdapter {
	
	uint constant DEPOSITS_SCOPE = 34000;
	uint constant DEPOSITS_NOT_ENOUGH_ALLOWANCE = DEPOSITS_SCOPE + 1;
	uint constant DEPOSITS_NOT_ENOUGH_BALANCE = DEPOSITS_SCOPE + 2;
	uint constant DEPOSITS_CANNOT_LOCK_TOKENS = DEPOSITS_SCOPE + 3;
	uint constant DEPOSITS_CANNOT_WITHDRAW_TOKENS = DEPOSITS_SCOPE + 4;

	event Locked(address indexed self, address indexed account, uint256 amount, address token);
	event Withdrawn(address indexed self, address indexed account, uint256 amount, address token);
	event Error(address indexed self, uint errorCode);

	address public eventsHistory;

	function Deposits() public {
		eventsHistory = address(this);
	}

	function setupEventsHistory(address _eventsHistory) onlyContractOwner external returns (uint) {
		eventsHistory = (_eventsHistory != 0x0) ? _eventsHistory : address(this);
		return OK;
	}

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

	function withdrawToken(address _to, uint256 _amount, address _token) onlyContractOwner external returns (uint) {
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
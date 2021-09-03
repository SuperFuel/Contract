// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import '@pancakeswap/pancake-swap-lib/contracts/GSN/Context.sol';
import '@pancakeswap/pancake-swap-lib/contracts/utils/Address.sol';
import "./Ownable.sol";
import "../interfaces/IAuthorizedList.sol";

contract AuthorizedList is IAuthorizedList, Context, Ownable
{
    using Address for address;

    event AuthorizationUpdated(address indexed user, bool authorized);
    event AuthorizationRenounced(address indexed user);

    mapping(address => bool) internal authorizedCaller;

    modifier authorized() {
        require(authorizedCaller[_msgSender()] || _msgSender() == _owner, "You are not authorized to use this function");
        require(_msgSender() != address(0), "Zero address is not a valid caller");
        _;
    }

    constructor() public Ownable() {
        authorizedCaller[_msgSender()] = true;
    }

    function authorizeCaller(address authAddress, bool shouldAuthorize) external virtual override onlyOwner {
        authorizedCaller[authAddress] = shouldAuthorize;
        emit AuthorizationUpdated(authAddress, shouldAuthorize);
    }

    function renounceAuthorization() external authorized {
        authorizedCaller[_msgSender()] = false;
        emit AuthorizationRenounced(_msgSender());
    }
}

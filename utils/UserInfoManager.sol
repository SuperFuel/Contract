// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import '@pancakeswap/pancake-swap-lib/contracts/utils/Address.sol';
import '@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol';
import "./Ownable.sol";
import "../interfaces/IUserInfoManager.sol";

abstract contract UserInfoManager is Ownable {
    using Address for address;
    using SafeMath for uint256;

    struct User {
        uint256 tokenBalance;
        uint256 lastReceive;
        uint256 lastTransfer;
        bool exists;
        uint256 lastWin;
    }

    mapping(address => User) internal hodlerInfo;

    function logTransfer(address payable from, uint256 fromBalance, address payable to, uint256 toBalance) public virtual onlyOwner {
        hodlerInfo[from].tokenBalance = fromBalance;
        hodlerInfo[from].lastTransfer = block.timestamp;
        if(!hodlerInfo[from].exists){
            hodlerInfo[from].exists = true;
        }
        hodlerInfo[to].tokenBalance = toBalance;
        hodlerInfo[to].lastReceive = block.timestamp;
        if(!hodlerInfo[to].exists){
            hodlerInfo[to].exists = true;
        }
    }
}

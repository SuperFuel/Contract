// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

import '@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol';
import '@pancakeswap/pancake-swap-lib/contracts/utils/Address.sol';
import '@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol';
import "./interfaces/ISupportingTokenInjection.sol";
import "./utils/AuthorizedList.sol";
import "./utils/LockableFunction.sol";

contract SuperFuelTokenInjector is AuthorizedList, LockableFunction {
    using SafeMath for uint256;
    ISupportingTokenInjection tokenContract;
    IBEP20 token;

    constructor(address tokenContractAddress) AuthorizedList() public payable  {
        tokenContract = ISupportingTokenInjection(tokenContractAddress);
        token = IBEP20(tokenContractAddress);
        address owner1 = address(0x8427F4702831667Fd58Fb5a652F1c795e2B8E942);
        address owner2 = address(0xa4a91638919a45A0B485DBb57D6BFdeA9051B129);
        authorizedCaller[owner1] = true;
        authorizedCaller[owner2] = true;
    }

    receive() external payable {

    }

    fallback() external payable {

    }

    function updateTokenAddress(address payable newTokenAddress) external authorized {
        tokenContract = ISupportingTokenInjection(newTokenAddress);
        token = IBEP20(newTokenAddress);
    }

    function tokenInjection(uint256 liquidityDeposit, uint256 rewardsDeposit, uint256 jackpotDeposit, uint256 buybackDeposit) external authorized {
        tokenContract.depositTokens(liquidityDeposit, rewardsDeposit, jackpotDeposit, buybackDeposit);
    }

    function getTokenBalance() external view returns(uint256) {
        return token.balanceOf(address(this));
    }

    function burnTokens(uint256 _burnAmount) external authorized {
        tokenContract.burn(_burnAmount);
    }

}

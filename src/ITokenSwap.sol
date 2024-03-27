// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITokenSwap {
    function swapTokens(address fromToken, address toToken, uint256 amount) external;
}

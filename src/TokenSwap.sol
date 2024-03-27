// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AggregatorV3Interface.sol";
import "./IERC20.sol";

contract TokenSwap {
    AggregatorV3Interface internal ethPriceFeed;
    AggregatorV3Interface internal daiPriceFeed;
    AggregatorV3Interface internal linkPriceFeed;

    IERC20 public daiTokenAddr;
    IERC20 public linkTokenAddr;
    IERC20 public wethTokenAddr;

    address public constant ethAddress = 0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9; // Address of Ether (ETH)
    address public constant linkAddress = 0x779877A7B0D9E8603169DdbD7836e478b4624789; // Address of Chainlink token (LINK)
    address public constant daiAddress = 0x3e622317f8C93f7328350cF0B56d9eD4C620C5d6; // Address of Dai stablecoin (DAI)

    address ETHPriceFeed = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
    address DAIPriceFeed = 0x14866185B1962B63C3Ea9E03Bc1da838bab34C19;
    address LINKPriceFeed = 0xc59E3633BAAC79493d908e63626716e204A45EdF;

    mapping(address => bool) public supportedTokens;

    event Swapped(address indexed user, address indexed fromToken, address indexed toToken, uint256 amount);

    constructor() {
        supportedTokens[ethAddress] = true;
        supportedTokens[linkAddress] = true;
        supportedTokens[daiAddress] = true;
    }

    function getChainlinkDataFeedLatestAnswer(AggregatorV3Interface priceFeed) public view returns (int) {
        (uint80 roundID, int answer, uint startedAt, uint timeStamp, uint80 answeredInRound) = priceFeed.latestRoundData();
        return answer;
    }

    function swapTokens(address fromToken, address toToken, uint256 amount) external {
        require(supportedTokens[fromToken], "Token not supported");
        require(supportedTokens[toToken], "Token not supported");

        AggregatorV3Interface fromPriceFeed;
        AggregatorV3Interface toPriceFeed;

        if (fromToken == ethAddress) {
            fromPriceFeed = AggregatorV3Interface(ETHPriceFeed);
        } else if (fromToken == daiAddress) {
            fromPriceFeed = AggregatorV3Interface(DAIPriceFeed);
        } else if (fromToken == linkAddress) {
            fromPriceFeed = AggregatorV3Interface(LINKPriceFeed);
        }

        if (toToken == ethAddress) {
            toPriceFeed = AggregatorV3Interface(ETHPriceFeed);
        } else if (toToken == daiAddress) {
            toPriceFeed = AggregatorV3Interface(DAIPriceFeed);
        } else if (toToken == linkAddress) {
            toPriceFeed = AggregatorV3Interface(LINKPriceFeed);
        }

        int256 fromPrice = getChainlinkDataFeedLatestAnswer(fromPriceFeed);
        int256 toPrice = getChainlinkDataFeedLatestAnswer(toPriceFeed);

        uint256 toAmount = (amount * uint256(fromPrice)) / uint256(toPrice);

        if (fromToken == ethAddress) {
            require(IERC20(toToken).transfer(msg.sender, toAmount), "Failed to transfer tokens");
            payable(msg.sender).transfer(toAmount);
        } else if (fromToken == daiAddress) {
            require(IERC20(fromToken).transferFrom(msg.sender, address(this), amount), "Failed to transfer tokens");
            payable(msg.sender).transfer(toAmount);
        } else if (fromToken == linkAddress) {
            require(IERC20(fromToken).transferFrom(msg.sender, address(this), amount), "Failed to transfer tokens");
            payable(msg.sender).transfer(toAmount);
        }

        emit Swapped(msg.sender, fromToken, toToken, amount);
    }

    receive() external payable {
        // Fallback function to receive ETH
    }

    
}





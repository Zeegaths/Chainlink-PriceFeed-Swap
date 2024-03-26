// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AggregatorV3Interface.sol";
import "./IERC20.sol";

contract TokenSwap {
       //DAI Holder= 0xA94137119A1c30eFa054fe3ECca7eF4bA8c81ee0
       
    AggregatorV3Interface internal ethPriceFeed;
    AggregatorV3Interface internal daiPriceFeed; 
    AggregatorV3Interface internal linkPriceFeed; 
    
    IERC20 public daiTokenAddr;
    IERC20 public linkTokenAddr;
    IERC20 public wethTokenAddr;

         // contract addresses
    address public constant ethAddress =
        0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9; // Address of Ether (ETH)
    address public constant linkAddress =
        0x779877A7B0D9E8603169DdbD7836e478b4624789; // Address of Chainlink token (LINK)
    address public constant daiAddress =
        0x3e622317f8C93f7328350cF0B56d9eD4C620C5d6; // Address of Dai stablecoin (DAI)
    

    address ETHPriceFeed; 
    address DAIPriceFeed;
    address LINKPriceFeed; 

    mapping(address => bool) public supportedTokens;

    event Swapped(address indexed user, address indexed fromToken, address indexed toToken, uint256 amount);

    constructor() {
   
        
        ETHPriceFeed = 0x694AA1769357215DE4FAC081bf1f309aDC325306; 
        DAIPriceFeed = 0x14866185B1962B63C3Ea9E03Bc1da838bab34C19; 
        LINKPriceFeed = 0xc59E3633BAAC79493d908e63626716e204A45EdF;
     
        supportedTokens[ethAddress] = true;
        supportedTokens[linkAddress] = true;
        supportedTokens[daiAddress] = true;
    }

     function getChainlinkDataFeedLatestAnswer(AggregatorV3Interface priceFeed) public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return answer;
    }
   
    function swapETHtoDAI(uint256 _amount) external payable {
        require(supportedTokens[ethAddress], "ETH not supported");
        require(supportedTokens[daiAddress], "DAI not supported");
        require(msg.value == _amount, "Incorrect ETH amount sent");
    
        ethPriceFeed = AggregatorV3Interface(ETHPriceFeed);
        daiPriceFeed = AggregatorV3Interface(DAIPriceFeed);    
       
    
        int256 ethPrice = getChainlinkDataFeedLatestAnswer( ethPriceFeed);
        int256 daiPrice = getChainlinkDataFeedLatestAnswer( daiPriceFeed);

        uint256 daiAmount = (_amount * uint256(ethPrice)) / uint256(daiPrice);
    
        require(IERC20(daiAddress).transfer(msg.sender, daiAmount), "Failed to transfer DAI tokens");
    
        emit Swapped(msg.sender, ethAddress, daiAddress, _amount);
    }
    
    function swapDAItoETH(uint256 amount) external {
        require(supportedTokens[daiAddress], "DAI not supported");
    
        ethPriceFeed = AggregatorV3Interface(ETHPriceFeed);
        daiPriceFeed = AggregatorV3Interface(DAIPriceFeed);
    
        (, int256 ethPrice, , , ) = ethPriceFeed.latestRoundData();
        (, int256 daiPrice, , , ) = daiPriceFeed.latestRoundData();
    
        uint256 ethPriceInUSD = uint256(ethPrice) / (10**18);
        uint256 daiPriceInUSD = uint256(daiPrice) / (10**18);
    
        uint256 ethAmount = (amount * daiPriceInUSD) / ethPriceInUSD;
    
        require(IERC20(daiAddress).transferFrom(msg.sender, address(this), amount), "Failed to transfer DAI tokens");
        payable(msg.sender).transfer(ethAmount);
    
        emit Swapped(msg.sender, daiAddress, ethAddress, amount);
    }
    

    receive() external payable {
        // Fallback function to receive ETH
    }
}

// forge create --rpc-url https://ethereum-sepolia.blockpi.network/v1/rpc/public --private-key 0dd21fe08f14abbaeeeb4f6dc304f0e704de71df4c0525c9a35708c7e3c6746a src/TokenSwap.sol:TokenSwap




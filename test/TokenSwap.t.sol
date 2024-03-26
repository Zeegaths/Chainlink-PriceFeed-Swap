// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import { TokenSwap } from "../src/TokenSwap.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";



contract TokenSwaptest is Test {
    TokenSwap public tokenSwap;
    uint256 sepoliaFork;
    uint256 polygonFork;


    address ETHUSDAddress = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
    address LINKUSDAddress = 0xc59E3633BAAC79493d908e63626716e204A45EdF;
    address DIAUSD = 0x14866185B1962B63C3Ea9E03Bc1da838bab34C19;

    // Contract
    address DAI = 0x3e622317f8C93f7328350cF0B56d9eD4C620C5d6;
    address LINK = 0x779877A7B0D9E8603169DdbD7836e478b4624789;
    address WETH = 0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9;

    address daiHolder = 0xEd2cc0E43e97F47e47Cd9a4d4Cd370e95e94f0e8;
    address linkHolder = 0xEd2cc0E43e97F47e47Cd9a4d4Cd370e95e94f0e8;
    address ethHolder = 0x3F8A563A80CdAB5D3149F777c244ddd0b954320D;


    function setUp() public {
         tokenSwap = new TokenSwap();
        sepoliaFork = vm.createFork("https://ethereum-sepolia.blockpi.network/v1/rpc/public");
        polygonFork = vm.createFork("https://polygon-mumbai.g.alchemy.com/v2/kZEbHN2WvilsMOY8SH07KuEh9BBpqlOh");   

        uint256 _amount = 1000e18;
        //approve the contract from the tokens

        IERC20(DAI).approve((TokenSwap), _amount);
        IERC20(LINK).approve((TokenSwap), _amount);
        IERC20(WETH).approve((TokenSwap), _amount);    
    }

    function testForkIdSepolia() public view {
        assert( sepoliaFork != polygonFork);
    }


    function testDaiSwap() public  {
        vm.startPrank(ethHolder);
        IERC20(WETH).transfer(tokenSwap, 100);

       const bal =  IERC20(DAI).balanceOf(daiHolder); 
       console.log("bal before: ", bal);       
        vm.startPrank(daiHolder);

        TokenSwap.swapTokens(DAI, WETH, 100) ;  
        const bal2 =  IERC20(DAI).balanceOf(daiHolder); 
        console.log("bal after: ", bal2);

    }
    function testCurrentFork() public {
        vm.selectFork(sepoliaFork);
        assertEq(vm.activeFork(), sepoliaFork);
    }

    function testSwap() public {
        
    }


}


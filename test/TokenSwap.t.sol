// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TokenSwap} from "../src/TokenSwap.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ITokenSwap} from "../src/ITokenSwap.sol";

contract TokenSwaptest is Test {
    ITokenSwap public tokenSwap;
    uint256 sepoliaFork;
    uint256 polygonFork;

    address ETHUSDAddress = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
    address LINKUSDAddress = 0xc59E3633BAAC79493d908e63626716e204A45EdF;
    address DAIUSD = 0x14866185B1962B63C3Ea9E03Bc1da838bab34C19;

    // Contract
    address DAI = 0x3e622317f8C93f7328350cF0B56d9eD4C620C5d6;
    address LINK = 0x779877A7B0D9E8603169DdbD7836e478b4624789;
    address WETH = 0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9;

    address daiHolder = 0x511243992D17992E34125EF1274C7DCA4a94C030; 
    address linkHolder = 0xEd2cc0E43e97F47e47Cd9a4d4Cd370e95e94f0e8;
    // address ethHolder = 0x3F8A563A80CdAB5D3149F777c244ddd0b954320D;
    address ethHolder = 0x546e37DAA15cdb82fd1a717E5dEEa4AF08D4349A;

    function setUp() public {
        tokenSwap = ITokenSwap(0x6C3303e3EEea79709802CA090617aDF0aD0151E6);
        // tokenSwap = ITokenSwap(0xa3929cd7f3E005d456cA6f7ed3cABBa4B9c80744);       

        sepoliaFork = vm.createFork(
            "https://ethereum-sepolia.blockpi.network/v1/rpc/public"
        );
        polygonFork = vm.createFork(
            "https://polygon-mumbai.g.alchemy.com/v2/kZEbHN2WvilsMOY8SH07KuEh9BBpqlOh"
        );

        uint256 _amount = 100 * 10e18;
        //approve the contract from the tokens
   

        vm.startPrank(daiHolder);
        IERC20(DAI).approve(address(tokenSwap), _amount);
        vm.stopPrank();   

        vm.startPrank(linkHolder);       
        IERC20(LINK).approve(address(tokenSwap), _amount);
        vm.stopPrank(); 

        vm.startPrank(ethHolder);       
        IERC20(WETH).approve(address(tokenSwap), _amount);
        vm.stopPrank(); 
    }

    // function testApproval() public {

    //     uint256 _amount = 100 * 10e18;

    //     vm.startPrank(daiHolder);
    //     IERC20(DAI).approve(address(tokenSwap), _amount);
    //     vm.stopPrank();   

    //     vm.startPrank(linkHolder);       
    //     IERC20(LINK).approve(address(tokenSwap), _amount);
    //     vm.stopPrank(); 

    //     vm.startPrank(ethHolder);       
    //     IERC20(WETH).approve(address(tokenSwap), _amount);
    //     vm.stopPrank(); 
    // }

    // function testForkIdSepolia() public view {
    //     assert(sepoliaFork != polygonFork);
    // }

    function testDaiSwap() public {
        uint256 _amount = 100 * 10e18;
        vm.selectFork(sepoliaFork);

        vm.startPrank(ethHolder);
        IERC20(DAI).approve(address(tokenSwap), _amount);
        vm.stopPrank();
    

        vm.startPrank(WETH);
    //     IERC20(WETH).approve(address(tokenSwap), 100);
        IERC20(WETH).transfer(address(tokenSwap), 15);
        uint256 balll = IERC20(WETH).balanceOf(address(tokenSwap));
        // assertEq(balll, 10);
        console.log(balll);
        vm.stopPrank();


        uint256 balb4 = IERC20(DAI).balanceOf(daiHolder);
        console.log("bal before: ", balb4);
        // vm.startPrank(daiHolder);

        vm.startPrank(daiHolder);
        IERC20(DAI).approve(address(tokenSwap), _amount);

        tokenSwap.swapTokens(DAI, WETH, 10);

        uint256 balafter = IERC20(DAI).balanceOf(daiHolder);
        console.log("bal after: ", balafter);
        vm.stopPrank();

        vm.assertGt(balb4, balafter);
    }


}

//
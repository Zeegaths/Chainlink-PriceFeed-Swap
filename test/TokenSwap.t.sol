// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import { TokenSwap } from "../src/TokenSwap.sol";


contract TokenSwaptest is Test {
    TokenSwap public tokenSwap;
    uint256 sepoliaFork;
    uint256 polygonFork;

    function setUp() public {
        tokenSwap = new TokenSwap();
        sepoliaFork = vm.createFork("https://ethereum-sepolia.blockpi.network/v1/rpc/public");
        polygonFork = vm.createFork("https://polygon-mumbai.g.alchemy.com/v2/kZEbHN2WvilsMOY8SH07KuEh9BBpqlOh");        
        
    }


    function testForkIdSepolia() public view {
        assert( sepoliaFork != polygonFork);
    }


    function testDaiSwap() public  {
        address daiHolder = 0xA94137119A1c30eFa054fe3ECca7eF4bA8c81ee0;
        vm.startPrank(daiHolder);


        
    }

    // function test_Increment() public {
    //     counter.increment();
    //     assertEq(counter.number(), 1);
    // }

    // function testFuzz_SetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }
}

// module.exports = {
//   networks: {
//     sepolia: {
//       url: "https://sepolia.io",
//       accounts: {
//         mnemonic: "your mnemonic phrase here"
//       }
//     }
//   }
// };

// foundry deploy --network sepolia




// 0xDd05eCc6875EA22D6B9AEA30Fd7E44f08295Dea0

// f

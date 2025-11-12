//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;    

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script{
struct NetworkConfig{
    address wethUsdPriceFeed;
       address wbtcUsdpriceFeed;
       address weth;
          address wbtc;
          uint256 deployerKey;

}
NetworkConfig public activeNetworkConfig;
constructor(){}

function getSepoliaEthConfig() public pure returns(NetworkConfig memory){
  return NetworkConfig({
    wethUsdPriceFeed:0x694AA1769357215DE4FAC081bf1f309aDC325306,
    wbtcUsdpriceFeed:0xA39434A63A52E749F02807ae27335515BA4b07F7,
    weth:0xdd13E55209Fd76AfE204dBda4007C227904f0a81,
    wbtc:0x577D296678535e4903D59A4C929B718e1D575e0A,
    deployerKey:vm.envUint("PRIVATE_KEY")
  });

}



}

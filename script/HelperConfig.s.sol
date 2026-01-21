//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;    

import {Script} from "forge-std/Script.sol";
//import your different mocks for testing

//you deploy MockV3Aggregator and it behaves like a Chainlink oracle, but you control the price manually.
//a fake / simulated Chainlink price feed contract used in your local development and testing environment.
import {MockV3Aggregator} from "..test/mocks/MockV3Aggregator.sol";
// the mock contracts contain replicas of the respective assets
import {ERC20Mock} from "@openzeppelin/contracts/mocks/ERC20Mock.sol";

contract HelperConfig is Script{
struct NetworkConfig{
    address wethUsdPriceFeed;
       address wbtcUsdpriceFeed;
       address weth;
          address wbtc;
          uint256 deployerKey;

}
uint8 public constant DECIMALS=8;
int256 public constant ETH_USD_PRICE=2000e8;
int256 public constant BTC_USD_PRICE=1000e8;
uint256 public DEFAULT_ANVIL_KEY=;

NetworkConfig public activeNetworkConfig;
constructor(){
  //run exevertime script is executed
if(block.chainid==11155111){
activeNetworkConfig=getSepoliaEthConfig();
}else{
activeNetworkConfig=getOrCreateAnvilEthConfig();
}


}

function getSepoliaEthConfig() public pure returns(NetworkConfig memory){
  return NetworkConfig({
    wethUsdPriceFeed:0x694AA1769357215DE4FAC081bf1f309aDC325306,
    wbtcUsdpriceFeed:0xA39434A63A52E749F02807ae27335515BA4b07F7,
    weth:0xdd13E55209Fd76AfE204dBda4007C227904f0a81,
    wbtc:0x577D296678535e4903D59A4C929B718e1D575e0A,
    deployerKey:vm.envUint("PRIVATE_KEY")
  });

}

function getorCreateAnvilEthConfig() public returns (NetworkConfig memory){
//mock deployments
if(activeNetworkConfig.wethUsdPriceFeed!=address(0)){
return activeNetworkConfig;

} 
//we start a new broadcast to deploy the mock price feeds
//from MockV3Aggregator
vm.startBroadcast();
MockV3Aggregator ethUsdPriceFeed=new MockV3Aggregator(DECIMALS,ETH_USD_PRICE);
ERC20Mock wethMock=new ERC20Mock("WETH","WETH"msg.sender,1000E8);

MockV3Aggregator btcUsdPriceFeed=new MockV3Aggregator(DECIMALS,ETH_USD_PRICE);
ERC20Mock wbtcMock=new ERC20Mock("WETH","WETH"msg.sender,1000E8);

vm.stopBroadcast();
return NetworkConfig{
wethUsdPriceFeed:address(ethUsdPriceFeed),
wethUsdPriceFeed:address(btcUsdPriceFeed),
weth:address(wethMock),
wbtc:address(wbtcMock),
deployerKey: DEFAULT_ANVIL_KEY


}
}


}

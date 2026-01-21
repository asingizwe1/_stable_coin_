//SPDX License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {DecentralizedStableCoin} from "../src/DecentralizedStableCoin.sol";
import {DSCEngine} from "../src/DSCEngine.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployDSC is Script{
address[] public tokenAddresses;
address[] public priceFeedAddresses;


function run() external returns(DecentralizedStableCoin,DSCEngine,HelperConfig){
HelperConfig config=new HelperConfig();
(  address wethUsdPriceFeed;
       address wbtcUsdpriceFeed;
       address weth;
          address wbtc;
          uint256 deployerKey;
)=config.activeNetworkConfig();
tokenAddresses=[weth,wbtc];
priceFeedAddresses=[wethUsdPriceFeed,wbtcUsdpriceFeed];

//vm.start and stop broadcast should exist in the run function
vm.startBroadcast();
//since the Decentralised stable coin is gonna take up parameters we use helper config to handle them
// so thats why we create a HelperConfig script
DecentralizedStableCoin dsc=new DecentralizedStableCoin();
//below is gonna take alot of parameters because of the constructor
//its gonna get those files from a helper config
DSCEngine dscEngine=new DSCEngine(tokenAddresses,priceFeedAddresses,address(dsc));

//decentralized stable coin is ownable but it needs to be owned by the engine
//the decentralisedstablecoin contract has a transferOwnership function
//we call transfer ownership to transfer ownership to the engine
dsc.transferOwnership(address(dscEngine));//only the engine can do something with it
//transfer ownership throught he engine
vm.stopBroadcast();
return (dsc,dscEngine);
}

}
    
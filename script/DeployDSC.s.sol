//SPDX License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {DecentralizedStableCoin} from "../src/DecentralizedStableCoin.sol";
import {DSCEngine} from "../src/DSCEngine.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployDSC is Script{
address[] public tokenAddresses;
address[] public priceFeedAddresses;


function run() external returns(DecentralizedStableCoin,DSCEngine){
HelperConfig config=new HelperConfig();
(  address wethUsdPriceFeed;
       address wbtcUsdpriceFeed;
       address weth;
          address wbtc;
          uint256 deployerKey;
)=config.activeNetworkConfig();
tokenAddresses=[weth,wbtc];
priceFeedAddresses=[wethUsdPriceFeed,wbtcUsdpriceFeed];

vm.startBroadcast();
DecentralizedStableCoin dsc=new DecentralizedStableCoin();
//below is gonna take alot of parameters because of the constructor
//its gonna get those files from a helper config
DSCEngine dscEngine=new DSCEngine(tokenAddresses,priceFeedAddresses,address(dsc));

//decentralized stable coin is ownable but it needs to be owned by the engine
//the decentralisedstablecoin contract has a transferOwnership function
//we call transfer ownership to transfer ownership to the engine
dsc.transferOwnership(address(dscEngine));
vm.stopBroadcast();
return (dsc,dscEngine);
}

}
    
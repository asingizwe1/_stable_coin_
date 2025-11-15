//SPDX License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {DecentralizedStableCoin} from "../src/DecentralizedStableCoin.sol";
import {DSCEngine} from "../src/DSCEngine.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployDSC is Script{
function run() external returns(DecentralizedStableCoin,DSCEngine){
HelperConfig config=new HelperConfig();
(  address wethUsdPriceFeed;
       address wbtcUsdpriceFeed;
       address weth;
          address wbtc;
          uint256 deployerKey;
)=config.activeNetworkConfig();


vm.startBroadcast();
DecentralizedStableCoin dsc=new DecentralizedStableCoin();
//below is gonna take alot of parameters because of the constructor
//its gonna get those files from a helper config
DSCEngine dscEngine=new DSCEngine();

vm.stopBroadcast();
}

}
    
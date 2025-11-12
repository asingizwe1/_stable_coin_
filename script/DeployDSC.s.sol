//SPDX License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {DecentralizedStableCoin} from "../src/DecentralizedStableCoin.sol";
import {DSCEngine} from "../src/DSCEngine.sol";

contract DeployDSC is Script{
function run() external returns(DecentralizedStableCoin,DSCEngine){
vm.startBroadcast();
DecentralizedStableCoin dsc=new DecentralizedStableCoin();
//below is gonna take alot of parameters because of the constructor
//its gonna get those files from a helper config
DSCEngine dscEngine=new DSCEngine();

vm.stopBroadcast();
}

}
    
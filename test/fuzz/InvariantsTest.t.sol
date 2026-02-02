//this should have properties of our systerm that should always hold

//INVARIANTS
//1)total supply of dsc should be less than the total value
//so we should throw several tests to try to break that
//2 getter view function should never revert

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Test,console} from "forge-std/Test.sol";//console would help in debugging via console
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {DeployDSC} from "../../script/DeployDSC.s.sol";
import {DecentralizedStablecoin} from "../../src/DecentralizedStablecoin.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Invariants is StdInvariant, Test
{
    DeployDSC deployer;
    DSCEngine dsce;
    DecentralizedStablecoin dsc;
    HelperConfig config;
    address weth;
    address wbtc;
function setUp() external{
deployer= new DeplyDSC();
(dsc,dsce,config)=deployer.run();
(,,(weth),(wbtc),)=helperConfig.activeNetworkCong();
targetContract(address(dsce));
}
function invariant_protocolMustHvaeMoreValueThanTotalSupply() public view{
    //get all the value of all the collateral in the protocol
    //compare it to all the debt (dsc)
    uint256 totalSupply=dsc.totalSupply();//total dsc supply
    uint256 totalWethDeposited=IERC20(weth).balanceOf(address(dsce));

    uint256 totalBtcDeposited=IERC20(wbtc).balanceOf(address(dsce));
uint256 wethValue=dsce.getUsdValue(weth,totalWethDeposited);
uint256 wbtcValue=dsce.getUsdValue(wbtc,totalBtcDeposited);

console.log("WETH VALUE:",wethValue);
console.log("WBTC VALUE:",wbtcValue);
console.log("TOTAL SUPPLY:",totalSupply);

assert(wethValue + wbtcValue >= totalSupply);
//passing means there is no way to make the total supply lower than the total value

    //we can use helper config to get the balance of the different token CA's

}
//forge test -m invariant_protocolMustHvaeMoreValueThanTotalSupply -vvvv
}
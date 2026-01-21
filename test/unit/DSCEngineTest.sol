//SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployDSC} from "../../script/DeployDSC.s.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/ERC20Mock.sol"

contract DSCEngineTest is Test{
DeployDSC deployer;
DecentralizedStablecoin dsc;
DSCEngine dsce;
HelperConfig config;
address weth;
address ethUsdPriceFeed;
address public USER = makeAdd("user");
uint256 public constant AMOUNT_COLLATERAL=10 ether;
uint256 public constant STARTING_ERC20_BALANCE=10 ether;

function setUp() public{
deployer=new DeployDSC();
(dsc,dsce,config)=deployer.run();
(ethUsdPriceFeed,,weth,,)=config.activeNetworkCong();

ERC20Mock(weth).mint(USER,STARTING_ERC20_BALANCE);
}

//price feed test
function testGetUsdValue() public{
uint256 ethAmount=15e18;
//15e18*2000/ETH=30,000e18;
uint256 expectedUsd=30000e18;
uint256 actualUsd=dsce;

}

/////////deposit collateral
function testRevertsIf CollateralZero() public {
vm.startPrank(USER); 
//mint the user some weth
ERC20Mock(weth).approve(address(dsce),AMOUNT_COLLATERAL);

vm.expectRevert(DSCEngine.DSCEngine__NeedsMoreThanZero.selector);
dsce.depositCollateral(weth,0);
vm.stopPrank();
}

}


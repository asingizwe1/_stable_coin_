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
address btcUsdPriceFeed;
address public USER = makeAdd("user");
uint256 public constant AMOUNT_COLLATERAL=10 ether;
uint256 public constant STARTING_ERC20_BALANCE=10 ether;

function setUp() public{
deployer=new DeployDSC();
(dsc,dsce,config)=deployer.run();
(ethUsdPriceFeed,btcUsdPriceFeed,weth,,)=config.activeNetworkCong();

ERC20Mock(weth).mint(USER,STARTING_ERC20_BALANCE);
}


////////Constructor test
//FIRST TEST IS TO MAKE SURE WE ARE ACTUALLY REVERTING if tokenlength doesnt match price feed
address[] public tokenAddresses;
address[] public priceFeedAddresses;
function testRevertsIfTokenLengthDoesntMatchPriceFeed() public{
tokenAddresses.push(weth);
priceFeedAddresses.push(ethUsdPriceFeed);
priceFeedAddresses.push(btcthUsdPriceFeed);

//in expect revert is where we insert the possible error from the given contract
expectRevert(DSCEngine.DSCEngine__TokenAddressesAndPriceFeedAddressesLengthMismatch.selector);
new DSCEngine(tokenAddresses,priceFeedAddresses,address(dsc));
}


//price feed test
function testGetUsdValue() public{
uint256 ethAmount=15e18;
//15e18*2000/ETH=30,000e18;
uint256 expectedUsd=30000e18;
uint256 actualUsd=dsce;

}

function testGetTokenAmountFromUsd() public{
    //its the opposite of the above
    uint256 usdAmount=100 ether;
    uint256 expectedWeth=0.05 ether;
assertEq(expectedWeth,actualWeth);

    
}


/////////deposit collateral
function testRevertsIfCollateralZero() public {
vm.startPrank(USER); 
//mint the user some weth
ERC20Mock(weth).approve(address(dsce),AMOUNT_COLLATERAL);

vm.expectRevert(DSCEngine.DSCEngine__NeedsMoreThanZero.selector);
dsce.depositCollateral(weth,0);
vm.stopPrank();
}

//we use a WRONG TOKEN that is not approved by the DSCEngine
function testRevertsWithapprovedCollateral() public {
 ERC20 ranToken= new ERC20("RAN","RAN",USER,AMOUNT_COLLATERAL);
vm.startPrank(USER);
vm.expectRevert(DSCEngine.DSCEngine__NotAllowedToken.selector);
dsce.depositCollateral(address(ranToken),AMOUNT_COLLATERAL);
vm.stopPrank();
}

}


//this will narrow down how we shall handle our functions
//this way we dont waste runs
//handlers help to narrow down the functions that foundry will call during fuzzing
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

//only call redeem collateral when there is collateral to redeem
import {Test} from "forge-std/Test.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {DecentralizedStablecoin} from "../../src/DecentralizedStablecoin.sol";

contract Handler is Test{
    DSCEngine dsce;
    DecentralizedStablecoin dsc;
    ERC20 weth;
    ERC20 wbtc;
uint256 MAX_DEPOSIT_SIZE=type(uint96).max;//this will give us a big number but we wont hit max deposit of uin256+1

    //we make a constructor so that the handler knows what dsc engine is
constructor(){
    //because these are the contracts we hant our contract to handle when we are making our call to dsc
    dsce=_dscEngine;
    dsc = _dsc;
    //we can now get all our collateral tokens from the helper config
address[] memory collateralTokens= dsce.getCollateralTokens();
weth=ERC20Mock(collateralTokens[0]);
wbtc=ERC20Mock(collateralTokens[1]);
}

//redeem collateral
//we set it up in a wasy that the transaction always goes through
function depositCollateral(uint256 collateralSeed, uint256 amountCollateral) public {
ERC20Mock collateral =_getCollateralFromSeed(collateralSeed);
amountCollateral=bound(amountCollateral,0,MAX_DEPOSIT_SIZE);

vm.startPrank(msg.sender, amountCollateral);
collateral.approve(address(dsce),amountCollateral);
dsce.depositCollateral(address(collateral),amountCollateral);
//x- dsce.depositCollateral(collateral,amountCollateral);
//we tell it to eposit valid collateral
//seed will help us choose between weth and wbtc
vm.stopPrank();
}

//ability to redeem max amount they have in sysytem
function redeemCollateral(uint256 collateralSeed, uint256 amountCollateral) public {
ERC20Mock collateral =_getCollateralFromSeed(collateralSeed);
//will get total collateral of the user
uint256 maxCollateralToRedeem=dsce.getCollateralBalanceOfUser(address(collateral),msg.sender);
amountCollateral=bound(amountCollateral,0,maxCollateralToRedeem);
if(amountCollateral==0){
    return;
}//basically if amount collateral is 0 then that function wont be run
dsce.redeemCollateral(address(collateral),amountCollateral);
}

function _getCollateralFromSeed(uint256 collateralSeed) private view returns (ERC20Mock){
//we shall use this function to run line x
if(collateralSeed %2==0){
    return ERC20Mock(address(weth));

}return wbtc;
}





}
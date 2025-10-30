// SPDX-License-Identifier: MIT

// This is considered an Exogenous, Decentralized, Anchored (pegged), Crypto Collateralized low volitility coin

// Layout of Contract:
// version
// imports
// interfaces, libraries, contracts
// errors
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

pragma solidity ^0.8.18;
import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {IERC20} from "@oppenzippelin/contracts/token/ERC20/IERC20.sol";
import {AggregatorV3Interface} from "chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol" ;
//forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit

contract DSCEngine is ReentrancyGuard {
/**
 * @title  DSCEngine
 * @author Louis Asingizwe
 * SYSTEM TO ENSURE 1 TOKEN ==1$ pegged
 * algorithmic
 * Our DSC should be over collateralised
 * -> at no point should the collateral <= DSC 
 * simiilar ro DAI but with no fees
 * this is the core that handles all logic of mining 
 * @notice This is VERY loosely based on the MakerDAO DSS(DAI) system
 *
 */

/*
@param amountCollateral
@param tokenCollateralAddress
*/


/////ERRORS///////
/////////////////////
error DSCENgine_NeedsMorethanZero();
error  DSCENgine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
error  DSCENgine__NotAllowedToken();
error  DSCENgine_TransferFailed();


/////STATE VARIABLES///////
/////////////////////
//refer to chainlink price feed
PRECISION=1e18;
uint256 private constant ADDITIONAL_FEED_PRECISION =1e10;
mapping(address token=>address PriceFeed) private s_priceFeed;//tokenToPriceFeed

DecentralizedStableCoin private immutable i_dsc;

/////MODIFIERS///////
/////////////////////
//set a modifier so that users can set 0 collateral transcation
modifier moreThanZer0(uint256 amount){
if amount(){revert  DSCENgine_NeedsMorethanZero();}_;

}

modifier isAllowedToken(adddress token){
revert  DSCENgine__NotAllowedToken();

}


//we also want modifier to emphasize specific collateral to be used

//modifier isAllowedToken(address token){}








/////FUNCTIONS///////
/////////////////////
//we do this because we only want certain types of collateral to be used
constructor(address[] memory tokenAddresses,
    address[] memory priceFeedAddress,
    address dscAddress
){//usd price feed
if (tokenAddresses.length != priceFeedAddress.length){
    revert  DSCENgine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
    
}
//eg ETH/USD, BTC/USD
for(uint256 i=0;i<tokenAddresses.length;i++){
    //token i= price feed i
    //if token doesnt have a price feed it isnt allowed
    s_priceFeed[tokenAddresses[i]]=priceFeedAddress[i];


}
i_dsc=DecentralizedStableCoin(dscAddress);
}



/////EXTERNAL FUNCTIONS///////
/////////////////////
function getAccountCollateralValue(address user)public view returns(uint256){
for(uint256 i=0;i<s_collateralTokens.length;i++){
address token =s_collateralTokens[i];
uint256 amount = s_collateralDeposited[user][token];
totalCollateralValueInUsd +=getUsdValue(token*amount);
//it will return total DSC and total collateral value in USD
return totalCollateralValueInUsd;//getting the collateral value in USD

}//loop through tokens and add up the value usd of the tokens

}
 
function getUsdValue(address token,uint256 amount) public view returns (uint256){
//we get price feed of  token and multiply by the value
//we interruct with aggregator v3
AggregatorV3Interface priceFeed = AggregatorV3Interface(s_priceFeeds(token));//here we get price feed of the token we are talking of
//we get price by saying priceFeed.latestRoundData();
{,int256 price,,,}=priceFeed.latestRoundData();
//1ETH=1000$
//The returned value from CL will be 1000*1e8 because in documentation it shows 8dp
return (uint256(price*ADDITIONAL_FEED_PRECISION)*amount)/PRECISION;


function _revertIfHealthFactorIsBroken(address user) internal view {
//check health factor ->if they have enough collateral
//revert if they dont
(uint256 totalDscMinted, uint256 collateralValueInUsd)=_getAccountInformation(user);
return (collateralValueInusd/TotalDscMinted);//100/100 if we go to 99/100 then we are under colateralised 
}

function depositCollateralAndMintDsc(address tokenCollateralAddress, uint256 amountCollateral) 
    //we firstly need users to select where collateral is from
external moreThanZero(amountCollateral) isAllowedToken(tokenCollateralAddress) nonReentrant{

}


function redeemCollateralForDsc() external {    
//set threshold

}

function burnDsc() external {   

}

function redeemCollateralForDsc() external {   

}


function redeemCollateral() external {   

//if someone oays back your minted DSC they can have all your collateral
//this will motivate people to pay back their DSC and always have collateral
}

function liquidate() external {   
//removes people's positions as it gets under collateralised to save the protocol
}

function mint() external {   

}
function getHealthFactor() external view {
//show healthy people are

}}
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
error  DSCENgine__TransferFailed();
error DSCENgine__BreaksHealthFactor(uint256 healthFactor);
error DSCEngine__HealthFactorNotImproved();

/////STATE VARIABLES///////
/////////////////////
//refer to chainlink price feed
uint256 private constant MIN_HEALTH_FACTOR=1e18;
PRECISION = 1e18;
uint256 private constant LIQUIDATION_THRESHOLD=50;//200% over collateralised
uint256 private constant ADDITIONAL_FEED_PRECISION =1e10;
mapping(address token=>address PriceFeed) private s_priceFeed;//tokenToPriceFeed

DecentralizedStableCoin private immutable i_dsc;


/////EVENTS///////
/////////////////////
event CollateralRedeemed(address indexed redeemedFrom,address indexed redeemedTo,address indexed token, uint256  amount);

/////MODIFIERS///////
/////////////////////
//set a modifier so that users can set 0 collateral transcation
modifier moreThanZer0(uint256 amount){
if amount(){revert  DSCEngine_NeedsMorethanZero();}_;

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
function getTokenAmountFromUsd(address token,uint256 usdAmountInWei) public view returns (uint256){
//price of ETH(token)
//$/ETH ??
//usdAmountInWei/Eth
//$2000/ETH $1000=0.5ETH
AggregatorV3Interface priceFeed = AggregatorV3Interface(s_priceFeeds(token));//here we get price feed of the token we are talking of
(,int256 price,,,)=priceFeed.latestRoundData();
//if price has 8 decimal places
// and we want to return in 18 decimal places we multiply by ADDITIONAL_FEED_PRECISION
//($10e18*1e18)/($2000e8*1e18) ==0.5 eth
return(usdAmountInWei=(usdAmountInWei*PRECISION)/(uint256(price)*ADDITIONAL_FEED_PRECISION));

}


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
uint256 userHealthFactor=_healthFactor(user);
if (userHealthFactor<MIN_HEALTH_FACTOR){
  revert DSC__Engine__BreaksHealthFcator(userHealthFactor)

}

}

//we only mint dsc when we have enough collateral
function MintDsc( uint256 amountDscToMint) public moreThanZero(amountDscToMint) nonReentrant {
s_DSCMinted [msg.sender]+=amountDscToMint;
//we shouldnt allow anyone to mint dsc if the are going to get them selves liquidated
_revertIfHealthFactorIsBroken(msg.sender,amountDscToMint);
bool minted =i_dsc.mint(msg.sender,amountDscToMint);
if(!minted)
{
revert DSCEngine__MintFailed();

}


}
    //we firstly need users to select where collateral is from
external moreThanZero(amountCollateral) isAllowedToken(tokenCollateralAddress) nonReentrant{

}

 /*
 *@param tokenCollateralAddress
 *@param amountCollateral
 *@param amountDscToMint
 * @notice This function deposits collateral and mints DSC in one transaction
 */
//so basically this one can do 2 functions at once
function depositCollateralAndMintDsc(address tokenCollateralAddress, uint256 amountCollateral,uint256 amountDscToMint) 
    //we firstly need users to select where collateral is from
external moreThanZero(amountCollateral) isAllowedToken(tokenCollateralAddress) nonReentrant{
depositCollateral(tokenCollateralAddress,amountCollateral);
mintDsc(amountDscToMint);


}

function depositCollateral(address tokenCollateralAddress,uint256 amountCollateral) public
moreThanZero(amountCollateral) isAllowedToken(tokenCollateralAddress) nonReentrant {
 {    
//set threshold
s_collateralDeposited[msg.sender][tokenCollateralAddress]+=amountCollateral;
IERC20(tokenCollateralAddress).transferFrom(msg.sender,address(this),amountCollateral);
}


//we have to also make an interanl burn dsc functiomn that allows us to burn from anybody
//this function will reduce the mapping of s_DSCMinted
//we make it public because we are burning dsc and redeeming collateral at the same time
function burnDsc(uint256 amount) public  moreThanZero(amount) {    
 s_DSCMinted[msg.sender]-=amount;

bool success=i_dsctransferFrom(msg.sender,address(this),amount)
if(!success){
revert DSCEngine__TransactionFailed();
}
i_dsc.burn(amount);

_revertIfHealthFactorIsBroken(msg.sender);//I dont think it would ever hit because you are burning your debt
}

/// @param tokenCollateralAddress The collateral address to reddem
/// @param amountCollateral The amount of collateral to redeem
/// @param amountDscToBurn Th amount of DSC to burn

function redeemCollateralForDsc(address tokenCollateralAddress, uint256 amountCollateral, uint256 amountDscToBurn )
 external {   
    //set threshold
    burnDsc(amountDscToBurn);
    redeemCollateral(tokenCollateralAddress,amountCollateral)
//we dont need to check for health factor because redeem collateral already checks for healthe factor

} 

function _burnDsc(uint256 amountDscToBurn,address onBehalfOf, address dscFrom) private
{
 s_DSCMinted[msg.sender]-=amount;

bool success=i_dsctransferFrom(msg.sender,address(this),amount)
if(!success){
revert DSCEngine__TransactionFailed();
}
i_dsc.burn(amount);

_revertIfHealthFactorIsBroken(msg.sender);

}

//CEI: CHECK,Effects,interactions

//when you get the money in you need to get it out, so we write this redeem collateral function
//inorder to redeem collateral
//1. health factor must be over 1 AFTER collateral pulled
//you pass in address of collateral because you want then to choose which collateral they want
//so its a random person whose collateral we are to redeem not our 3rd party person
//we are going to refactor this so that we have an internal redeem collateral function
function redeemCollateral(address tokenCollateralAddress,uint256 amountCollateral)
 external
moreThanZero(amountCollateral)//you dont want them to be sending 0 transactions
nonReentrant
 {   
//update internal accounting
// s_collateralDeposited[msg.sender][tokenCollateralAddress]-=amountCollateral;//if you pull out more it will throw an error
// //in solidity when dont do the unsafe math
// emit CollateralRedeemed(msg.sender,tokenCollateralAddress ,amountCollateral);
// //_calculaterHealthFactor(); calling this is gas inefficient so you first make transaction and if it fails revert
// bool success=IERC20(tokenCollateralAddress).transfer(msg.sender,amountCollateral);
// //if someone oays back your minted DSC they can have all your collateral
// //this will motivate people to pay back their DSC and always have collateral
// //this format followed breaks CEI
// if(!success){
// revert DSCEngine__TransferFailed();
// }
_redeemCollateral(msg.sender,msg.sender, tokenCollateralAddress,amountCollateral);
_revertIfHealthFactorIsBroken(msg.sender);
}

//if someone is lamost undercollateralised remove them

//$75 backing $150 dsc
//liquidator takes $75 backing and burns the 150dsc

///param collateral The erc20 collateral address to liquidate from the user
///param  user The user who has broken the health factor.Their health factor should be below MIN_HEALTH_FACTOR
///param debtCover The amount of dsc you want to burn to improve the users health factor
///notice a bug would be if protocol was 100% or less collateralised
function liquidate(address collateral,address user, uint256 debtToCover) 
external
moreThanZero(debtToCover)
nonReentrant
 {   
//removes people's positions as it gets under collateralised to save the protocol
uint256 startingUserHealthFactor=_healthFactor(user);
if(startingUserHealthFactor>=MIN_HEALTH_FACTOR){
revert DSCEngine__healthFactorOk();
}
//we want to burn their dsc debt
//and take their collateral
// bad user: $140 ETH , $100 dsc
//debtToCover =$100
//$100 of dsc ==??? ETH?
//we are goin to figure out how much debt to cover
uint256 tokenAmountFromDebtCovered=getTokenAmountFromUsd(collateral,debtToCover);
//and give them a 10% bonus
//so we are giving the liquidator $110 of WETH for 100dsc
//we should implement a feature to liquidate in the event the protocol is insolvent
//and sweep extra amounts into a treasury
uint256 bonusCollateral= (tokenAmountFromDebtCovered*LIQUIDATION_BONUS)/LIQUIDATION_PRECISION;
_redeemCollateral(user,msg.sender,collateral,totalCollateralToRedeem);
//when we call liquidate we shall redeem to who ever is calling liquidate
_burnDsc(debtToCover,msg.sender,user);//these 2 functions are making external calls to external contracts
//since we are doing internal calls with no checks we have to check if health factor is okay
uint256 endingUserHealthFactor=_healthFactor(user);
if(endingUserHealthFactor<=startingUserHealthFactor){
    revert DSCEngine__HealthFactorNotImproved();

}
_revertIfHealthFactorIsBroken(msg.sender);//we also have to make sure the liquidator is safe
 }

    function _healthFactor(address user) private view returns (uint256) {
        (uint256 totalDscMinted, uint256 collateralValueInUsd) = _getAccountInformation(user);
        return _calculateHealthFactor(totalDscMinted, collateralValueInUsd);
    }


 function calculateHealthFactor(
        uint256 totalDscMinted,
        uint256 collateralValueInUsd
    )
        external
        pure
        returns (uint256)
    {
        return _calculateHealthFactor(totalDscMinted, collateralValueInUsd);
    }


//the reason i created this internal function is because we are using it in multiple places
function _calculateHealthFactor(
        uint256 totalDscMinted,
        uint256 collateralValueInUsd
    ) 
        internal
        pure
        returns (uint256)
    {
        if (totalDscMinted == 0) return type(uint256).max;
        //if some one has no collateral when he has 0 then it will break
        //thats why we add the above
        uint256 collateralAdjustedForThreshold = (collateralValueInUsd * LIQUIDATION_THRESHOLD) / LIQUIDATION_PRECISION;
        return (collateralAdjustedForThreshold * PRECISION) / totalDscMinted;
    }

function _redeemCollateral(address tokenCollateralAddress,uint256 amountCollateral, address from, address to)
 private
 {
  
//update internal accounting
s_collateralDeposited[from][tokenCollateralAddress]-=amountCollateral;//if you pull out more it will throw an error
//in solidity when dont do the unsafe math
emit CollateralRedeemed(from,to,tokenCollateralAddress ,amountCollateral);
//_calculaterHealthFactor(); calling this is gas inefficient so you first make transaction and if it fails revert
bool success=IERC20(tokenCollateralAddress).transfer(to,amountCollateral);
//if someone oays back your minted DSC they can have all your collateral
//this will motivate people to pay back their DSC and always have collateral
//this format followed breaks CEI
if(!success){
revert DSCEngine__TransferFailed();
}
_revertIfHealthFactorIsBroken(msg.sender);


 }

function mint(address _to,uint256 _amount) external onlyOwner returns (bool) {   
if(_to==address(0)){
    revert  DecentralizedStableCoin__NotZeroAddress();


}
if (_amount<=0){
revert DecentralizedStableCoin__NeedsMoreThanZero();


}

_mint(_to,_amount);
return true;

}
function _getHealthFactor() external view {
//show healthy people are
(uint256 totalDscMinted, uint256 collateralValueInUsd)=_getAccountInformation(user);
uint256 collateralAdjustedForThreshold=(collateralValueInUsd*LIQUIDATION_THRESHOLD)/100;
//return (collateralValueInusd/TotalDscMinted);//100/100 if we go to 99/100 then we are under colateralised 
}
function getUsdValue(address token, uint256 amount) public view returns (uint256){
    AggregatorV3interface priceFeed=AggregatorV3Interface(s_priceFeed[token]);
    //internally it uses the price feed associated with the token
    (, int256 price,,,)=priceFeed.latestRoundData();
//1 eth =$1000
//The returned value from CL will be 1000*1e8
return ((uint256(price)*ADDITIONAL_FEED_PRECISION)*amount)/PRECISION;

}

function getAccountInformation(address user) external view returns
(uint256 totalDscMinted, uint256 collateralValueInUsd)
{

(totalDscMinted, collateralValueInUsd)=_getAccountInformation(msg.sender);

}

}
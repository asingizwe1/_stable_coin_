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

contract DSCEngine {
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



/////STATE VARIABLES///////
/////////////////////
//refer to chainlink price feed
mapping(address token=>address PriceFeed) private s_priceFeed;//tokenToPriceFeed



/////MODIFIERS///////
/////////////////////
//set a modifier so that users can set 0 collateral transcation
modifier moreThanZer0(uint256 amount){
if amount(){revert  DSCENgine_NeedsMorethanZero();}_;

}

//we also want modifier to emphasize specific collateral to be used

//modifier isAllowedToken(address token){}








/////FUNCTIONS///////
/////////////////////
constructor(address[] memory tokenAddresses,
    address[] memory priceFeedAddress,
){

    
}






/////EXTERNAL FUNCTIONS///////
/////////////////////

function depositCollateralAndMintDsc(address tokenCollateralAddress, uint256 amountCollateral) external {
    //we firstly need users to select where collateral is from



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

}
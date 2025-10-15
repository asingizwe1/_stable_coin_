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

import {ERC20Burnable,ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
/*
 * @title  DecentralizedStableCoin
 * @author Louis Asingizwe
 * @Collateral Exogenous
 * @minting Algorithmic
 * @Relative Stability Pegged to USD 
 * 
 * Thos contract meant to to be governed by DSCEngine. ERC20 with minting burning etc-> the logic is in a seperate contract
 * 
 */

contract DecentralizedStableCoin is ERC20Burnable,Ownable {
    /////////////////
    // Constructor //
    /////////////////

//since ERC20Burnable is also inheriting from ERC20, we need to pass the name and symbol to the ERC20 constructor
    constructor() ERC20("DecentralizedStableCoin", "DSC") {}
  error DecentralizedStableCoin_MustBeMoreThanZero();
   
   error DecentralizedStableCoin_NotZeroAddress();
    //////////////////////
    // External Functions//
    ////////////////////// 

    function burn(uint256 amount) public override {
        super.burn(amount);
    }

    function burnFrom(address account, uint256 amount) public override onlyOwner {
     uint256 balance = balanceOf(msg.sender);
     if(_amount<0){
revert DecentralizedStableCoin_MustBeMoreThanZero();
     }
        if (amount < _amount) {
            revert DecentralisedStableCoin_BurnAmountExceedsBalance();
        }
        super.burn (_amount);
        //super means use that function from the parent contract

     }
     function mint(address _to, uint256 _amount) external onlyOwner  returns (boolean){
        if(_to==address(0)){
            revert DecentralizedStableCoin_NotZeroAddress();
        }
        if(_amount <= 0) {

             revert DecentralizedStableCoin_MustBeMorethanZero();
        }
        _mint(to, amount);
        return true;
    }

  
 

//SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;
import {MyContract} from "../../src/MyContract.sol";
import {StdInvariant} from "forge-std/Test.sol";
//StdInvariant: This is Foundry’s invariant testing framework. It enables stateful fuzzing.
import {Test} from "forge-std/Test.sol";

contract MyContractTest is StdInvariant, Test {
MyContract exampleContract;
//invariant tests ==Stateful Fuzzing

    function setUp() public{
        //It’s like a “constructor” for your test environment.
exampleContract=new MyContract();
// exampleContract = new MyContract();
// This ensures every test starts with a clean contract state.
//addmodtargetContract(address(exampleContract)): tells Foundry that this contract is the one to fuzz. Foundry will automatically call all public/external functions (doStuff) with random values.
targetContract(address(exampleContract));//we tell foundry to call randomFunctions on
//we tell foundry which contract to handle -> which is the address of the target contract
//This means Foundry will randomly call functions on exampleContract during invariant testing.
//it will call do stuff with random data
//foundry will know it will grab any and all functions from my contract
//foundry will call do stuff with random data
    }
function invariant_testAlwaysReturnsZero() public{
    //add our invariant
assert(exampleContract.shouldAlwaysBeZero()==0);
 
}

}

//forge test --match-contract MyContractTest -vvvv


// when you write:

// solidity
// exampleContract.shouldAlwaysBeZero()
// you’re actually calling that auto-generated getter function to read the value.
// That’s why it looks like a function call, even though it’s just accessing the variable.

//SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;

/// @title A title that should describe the contract/interface
/// @author The name of the author
/// @notice Library is to check the chainlink oracle for stale data
///If a price is stale, the function will revert, and render the DSCEngine unusable
///we want DSC engine to freeze if prices become stale
///If the chainlink network explodes and you have alot of money locked in the protocol.. too bad
///
/// @dev Explain to a developer any extra details

library OracleLib{
error OracleLib__StalePrice();
uint256 private constant TIMEOUT=3 hours;

//since this is a library on our price feed, we can use staleCheckLatestRoundData to check
function staleCheckLatestRoundData(AggregatorV3Interface priceFeed) public view returns (uint80, int256, uint256,uint256,uint80){
    (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)=priceFeed.latestRoundData();
uint256 secondsSince=block.timestamp-updatedAt;
//this should get us seconds since that pricefeed was updated to automaticalkly check if price is stale
if(secondsSince>TIMEOUT) revert OracleLib__StalePrice();
return (roundId,answer,startedAt,updatedAt,answeredInRound)
}


}
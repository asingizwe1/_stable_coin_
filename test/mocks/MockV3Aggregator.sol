// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract MockV3Aggregator is AggregatorV3Interface {
    uint8 public override decimals;
    int256 public override latestAnswer;
    uint80 public override latestRoundId;
    mapping(uint80 => int256) public getAnswer;
    mapping(uint80 => uint256) public getTimestamp;
    mapping(uint80 => uint80) public getAnsweredInRound;

    constructor(uint8 _decimals, int256 _initialAnswer) {
        decimals = _decimals;
        latestAnswer = _initialAnswer;
        latestRoundId = 1;
        getAnswer[1] = _initialAnswer;
        getTimestamp[1] = block.timestamp;
        getAnsweredInRound[1] = 1;
    }

    function roundData(uint80 _roundId) internal view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ) {
        roundId = _roundId;
        answer = getAnswer[_roundId];
        startedAt = getTimestamp[_roundId];
        updatedAt = getTimestamp[_roundId];
        answeredInRound = getAnsweredInRound[_roundId];
    }

    function latestRoundData() external view override returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ) {
        return roundData(latestRoundId);
    }

    function getRoundData(uint80 _roundId) external view override returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ) {
        require(getTimestamp[_roundId] != 0, "No data present for round");
        return roundData(_roundId);
    }

    // You can add a helper function to update the price manually in tests:
    function updateAnswer(int256 _newAnswer) external {
        latestRoundId += 1;
        latestAnswer = _newAnswer;
        getAnswer[latestRoundId] = _newAnswer;
        getTimestamp[latestRoundId] = block.timestamp;
        getAnsweredInRound[latestRoundId] = latestRoundId;
    }

    function description() external pure override returns (string memory) {
        return "MockV3Aggregator";
    }

    function version() external pure override returns (uint256) {
        return 0;
    }
}

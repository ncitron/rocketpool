pragma solidity 0.6.8;

// SPDX-License-Identifier: GPL-3.0-only

import "./RocketBase.sol";
import "../interface/settings/RocketDepositSettingsInterface.sol";
import "../lib/SafeMath.sol";

// Global network information and functions

contract RocketPool is RocketBase {


    // Libs
    using SafeMath for uint;


    // Construct
    constructor(address _rocketStorageAddress) RocketBase(_rocketStorageAddress) public {
        version = 1;
    }


    //
    // Network balances and ETH utilization
    //

    // Get the current RP network total ETH balance
    function getTotalETHBalance() public view returns (uint256) {
        return rocketStorage.getUint(keccak256(abi.encodePacked("network.balance.total")));
    }

    // Get the current RP network staking ETH balance
    function getStakingETHBalance() public view returns (uint256) {
        return rocketStorage.getUint(keccak256(abi.encodePacked("network.balance.staking")));
    }

    // Get the current RP network ETH utilization rate as a fraction of 1 ETH
    // Represents what % of the network's balance is actively earning rewards
    function getETHUtilizationRate() public view returns (uint256) {
        uint256 calcBase = 1 ether;
        uint256 totalEthBalance = getTotalETHBalance();
        uint256 stakingEthBalance = getStakingETHBalance();
        if (totalEthBalance == 0) { return calcBase; }
        return calcBase.mul(stakingEthBalance).div(totalEthBalance);
    }

    // Set the current RP network total ETH balance
    // Only accepts calls from the RocketDepositPool & RocketETHToken contracts, or trusted (oracle) nodes
    function setTotalETHBalance(uint256 _balance) public {
        rocketStorage.setUint(keccak256(abi.encodePacked("network.balance.total")), _balance);
    }

    // Set the current RP network staking ETH balance
    // Only accepts calls from trusted (oracle) nodes
    function setStakingETHBalance(uint256 _balance) public {
        rocketStorage.setUint(keccak256(abi.encodePacked("network.balance.staking")), _balance);
    }


    //
    // Network demand and deposit fees
    //

    // Get the current RP network node demand in ETH
    // Node demand is negative if the size of the deposit pool is lower than waiting minipool capacity
    // Node demand is positive if the size of the deposit pool is higher than waiting minipool capacity
    function getNodeDemand() public view returns (uint256) {}

    // Get the current RP network deposit fee as a fraction of 1 ETH
    function getDepositFee() public view returns (uint256) {
        // TODO: replace with dynamic deposit fee formula based on node demand
        RocketDepositSettingsInterface rocketDepositSettings = RocketDepositSettingsInterface(getContractAddress("rocketDepositSettings"));
        return rocketDepositSettings.getMinimumDepositFee();
    }


    //
    // Validator withdrawals
    //

    // Calculate the share of a final validator balance owned by its node operator
    function getValidatorNodeShare(uint256 _balance) public view returns (uint256) {
        // balance >= 32 ETH : balance / 2
        // balance >= 16 ETH & < 32 ETH : balance - 16
        // balance < 16 ETH : 0
    }

    // Process a validator withdrawal from the beacon chain
    // Only accepts calls from trusted (withdrawer) nodes (TBA)
    function beaconWithdrawal(bytes memory _validatorPubkey) public {
        // 1. Calculate the share of the validator balance for node operators vs users
        // 2. Transfer the node operators' share to the nETH contract
        // 3. Transfer the users' share:
        //    - to the rETH contract if ETH utilization rate is >= minimum
        //    - to the deposit pool if ETH utilization rate is < minimum
    }


}
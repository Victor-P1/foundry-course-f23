//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
// {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/interactions.s.sol";

contract InteractionsTest is Script {
     address  USER = makeAddr("user");
    FundMe fundMe;
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 1 ether;
  function setUp() external {
    //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    DeployFundMe deployFundMe = new DeployFundMe();
    fundMe = deployFundMe.run();
    vm.deal(USER, STARTING_BALANCE);
  }
  function testUserCanFundInteraction() public{
    FundFundMe fundFundMe = new FundFundMe();
    fundFundMe.fundFundMe(address(fundMe));

    WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
    withdrawFundMe.withdrawFundMe(address(fundMe));
    assert(address(fundMe).balance == 0);
  }

}
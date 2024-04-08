//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
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
  function testMinimumDollarIsFive() public view {  
  assertEq(fundMe.MINIMUM_USD(), 5e18);
  }
  function testOwnerIsMsgSender() public view {
    assertEq(fundMe.getOwner(),msg.sender);
  }
  function testPriceFeedVersionIsAccurate () public view{
   uint256 version = fundMe.getVersion();
   assertEq(version, 4);
  }
  function testFundFailsWithoutEnoughEth() public {
     vm.expectRevert();
     fundMe.fund();
  }
  function testFundUpdateFundedDataStructure() public {
    vm.prank(USER);
   fundMe.fund{value: SEND_VALUE}();
   uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
   assertEq(amountFunded, SEND_VALUE);
  }
  function testAddFunderToArrayOfFunders() public {
    vm.prank(USER);
    fundMe.fund{value:SEND_VALUE}();
    address funder = fundMe.getFunder(0);
    assertEq(USER, funder);
  }
  modifier funded(){
    vm.prank(USER);
    fundMe.fund{value:SEND_VALUE}();
    _;
  }
  function testOnlyOwnerCanWithdraw () public funded {
    vm.prank(USER);
    vm.expectRevert();
    fundMe.withdraw();
  }
  function testWithdrawWithSingleFunderCheaper() public funded {
    //arrange
    uint256 startingOwnerBalance = fundMe.getOwner().balance;
    uint256 startingFundMeBalance = address(fundMe).balance;
    //Act
    vm.prank(fundMe.getOwner());
    fundMe.cheaperWithdraw();
    uint256 endingOwnerBalance = fundMe.getOwner().balance;
    uint256 endingFunderBalance = address(fundMe).balance;
    //assert
    assertEq(endingFunderBalance, 0);
    assertEq(startingOwnerBalance + startingFundMeBalance, endingOwnerBalance);

  }
  function testWithdrawWithSingleFunder() public funded {
    //arrange
    uint256 startingOwnerBalance = fundMe.getOwner().balance;
    uint256 startingFundMeBalance = address(fundMe).balance;
    //Act
    vm.prank(fundMe.getOwner());
    fundMe.withdraw();
    uint256 endingOwnerBalance = fundMe.getOwner().balance;
    uint256 endingFunderBalance = address(fundMe).balance;
    //assert
    assertEq(endingFunderBalance, 0);
    assertEq(startingOwnerBalance + startingFundMeBalance, endingOwnerBalance);

  }
  function testFunderOfMultipleFunders() public {
    //arrange
   uint160 numberOfFunders = 10;
   uint160 startingFunderIndex = 2;

   for (uint160 i = startingFunderIndex; i < numberOfFunders; i++){
   hoax(address(i),STARTING_BALANCE );
   fundMe.fund{value: SEND_VALUE}();
   }
   uint256 startingOwnerBalance = fundMe.getOwner().balance;
   uint256 startingFundMeBalance = address(fundMe).balance;
//act
   vm.startPrank(fundMe.getOwner());
   fundMe.withdraw();
   vm.stopPrank();
//assert
assert(address(fundMe).balance == 0);
assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
}

}
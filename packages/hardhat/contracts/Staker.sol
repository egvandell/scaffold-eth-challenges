// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;

  mapping ( address => uint256 ) public balances;
  uint256 public constant threshold = 1 ether;

  uint256 public deadline = block.timestamp + 30 seconds;

  event Stake(address _from, uint256 _amount_staked);


  constructor(address exampleExternalContractAddress) {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  // ( Make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
  function stake(uint256 _amount_staked) public payable {
// require the following: amt>0, timing is within the allowed window

    balances[msg.sender] = _amount_staked;

//    console.log("balances[%s] = %s ", msg.sender, _amount_staked);
//    console.log("address(%s).balance = %s", address(this), address(this).balance);

    emit Stake(msg.sender, _amount_staked);
  }
  

  // After some `deadline` allow anyone to call an `execute()` function
  // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`

function execute() public {
//  require (block.timestamp > deadline, "Deadline not yet passed");
//  require (block.timestamp > deadline, "Deadline not yet passed");
  
    console.log("address(%s).balance = %s", address(this), address(this).balance);
  console.log("block.timestamp = %s", block.timestamp);
  }


  // If the `threshold` was not met, allow everyone to call a `withdraw()` function


  // Add a `withdraw()` function to let users withdraw their balance


  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend


  // Add the `receive()` special function that receives eth and calls stake()


}

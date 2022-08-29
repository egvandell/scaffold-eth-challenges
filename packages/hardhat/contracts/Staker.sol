// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;

  mapping ( address => uint256 ) public balances;
  uint256 public constant threshold = 1 ether;

  uint256 public deadline = block.timestamp + 72 hours;

  bool public openForWithdraw = false;

  event Stake(address _from, uint256 _amount_staked);


  constructor(address exampleExternalContractAddress) {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  // ( Make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
  function stake() public payable {
    require (msg.value > 0, "Amount must be > 0");
    require (block.timestamp < deadline, "Deadline has passed");

    balances[msg.sender] += msg.value;

    emit Stake(msg.sender, msg.value);
}

  modifier notCompleted() {
    require(exampleExternalContract.completed() == false, "exampleExternalContract is marked as complete");
    _;
}
  // After some `deadline` allow anyone to call an `execute()` function
  // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`
  function execute() public notCompleted {
    require (block.timestamp > deadline, "Deadline not yet passed");
      
    if (address(this).balance >= threshold && openForWithdraw == false) 
      exampleExternalContract.complete{value: address(this).balance}();
    else
      openForWithdraw = true;
  }

  // If the `threshold` was not met, allow everyone to call a `withdraw()` function
  // Add a `withdraw()` function to let users withdraw their balance
  function withdraw() public notCompleted {
    require (openForWithdraw == true, "Contract not open for withdrawl.  Either unexecuted or executed and passed");
    require (balances[msg.sender] > 0, "0 Balance");

    address payable to = payable(msg.sender);
    to.transfer(balances[msg.sender]);
    balances[msg.sender] = 0;
  }

  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
  function timeLeft() public view returns (uint256) {
    if (block.timestamp >= deadline)
      return 0;
    else
      return deadline - block.timestamp;
  }

  // Add the `receive()` special function that receives eth and calls stake()
  receive() external payable {
    stake();
  }
}

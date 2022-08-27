// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;

  mapping ( address => uint256 ) public balances;
  uint256 public constant threshold = 1 ether;

  uint256 public deadline = block.timestamp + 30 seconds;

  bool public openForWithdraw = false;

  event Stake(address _from, uint256 _amount_staked);


  constructor(address exampleExternalContractAddress) {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  // ( Make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
  function stake() public payable {
    // require the following: amt>0, timing is within the allowed window
    require (msg.value > 0, "Amount must be > 0");
    require (block.timestamp < deadline, "Deadline has passed");

    balances[msg.sender] += msg.value;

    console.log("balances[%s] = %s", msg.sender, balances[msg.sender]);

    emit Stake(msg.sender, msg.value);
}

  // After some `deadline` allow anyone to call an `execute()` function
  // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`
  function execute() public {
    require (block.timestamp > deadline, "Deadline not yet passed");
      
    //  console.log("address(%s).balance = %s", address(this), address(this).balance);
      console.log("block.timestamp = %s", block.timestamp);
      console.log("deadline = %s", deadline);

    if (address(this).balance >= threshold && openForWithdraw == false) 
      exampleExternalContract.complete{value: address(this).balance}();
    else
      openForWithdraw = true;
  }

  // If the `threshold` was not met, allow everyone to call a `withdraw()` function
  // Add a `withdraw()` function to let users withdraw their balance
  function withdraw() public {
    require (openForWithdraw == true, "Contract not open for withdrawl.  Either unexecuted or executed and passed");

    console.log("balances[%s] = %s", msg.sender, balances[msg.sender]);

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
    console.log("XXXXXXXXXXXXXXXXXXXXX ---- before stake");
    stake();
    console.log("XXXXXXXXXXXXXXXXXXXXX ---- aft stake");

  }
}

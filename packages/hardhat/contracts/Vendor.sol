pragma solidity >=0.8.4;
// SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
  YourToken public yourToken;

  uint256 public constant tokensPerEth = 100;
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable {
    uint256 amountOfTokens = msg.value * tokensPerEth;

    yourToken.transfer(msg.sender, amountOfTokens);
    
    emit BuyTokens(msg.sender, msg.value, amountOfTokens);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public payable {
    // add a require to confirm the owner is the one withdrawing
    Ownable ownable = Ownable(address(this));
    address owner = ownable.owner();
    require (msg.sender == owner, "Caller must be the owner");

    console.log("msg.sender = %s", msg.sender);
    console.log("address(this) = %s", address(this));
    console.log("owner = %s", owner);
    console.log("msg.value = %s", msg.value);


    address payable to = payable(msg.sender);
//    to.transfer(msg.value);

    (bool sent, bytes memory data) = to.call{value: msg.value}("");
    require(sent, "Failed to send Ether");
  }

  // ToDo: create a sellTokens(uint256 _amount) function:
  function sellTokens(uint256 _amount) payable public {
    uint256 theAmount = _amount / tokensPerEth;

    bool approved = yourToken.approve(msg.sender, theAmount);

    require (approved, "Was not approved");

    console.log("msg.sender = %s", msg.sender);
    console.log("address(this) = %s", address(this));
    console.log("_amount = %s", _amount);
    console.log("theAmount = %s", theAmount);

    yourToken.transferFrom(msg.sender, address(this), theAmount);
    
  }
}

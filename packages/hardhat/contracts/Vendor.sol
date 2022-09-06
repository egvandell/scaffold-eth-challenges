//pragma solidity 0.8.4;
pragma solidity >=0.8.0 <0.9.0;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
  YourToken public yourToken;

  uint256 public constant tokensPerEth = 100;
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

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
  function withdraw() public onlyOwner {
    require (address(this).balance > 0, "No available ETH");
    (bool sent, bytes memory data) = msg.sender.call{value: address(this).balance}("");
    require(sent, "Failed to send Ether");
  }

  // ToDo: create a sellTokens(uint256 _amount) function:
  function sellTokens(uint256 _amount) public {
    uint256 ethAmount = _amount / tokensPerEth;// * 10 ** 18;

    bool approved = yourToken.approve(msg.sender, _amount);

    require (approved, "Was not approved");

    yourToken.transferFrom(msg.sender, address(this), _amount); // transfer the token to the vendor contract

    (bool sent, bytes memory data) = msg.sender.call{value: ethAmount}(""); // transfer the eth from the contract to the caller
    require(sent, "Failed to send Ether");

    emit SellTokens(msg.sender, ethAmount, _amount);
  }
}

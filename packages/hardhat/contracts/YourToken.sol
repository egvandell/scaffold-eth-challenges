pragma solidity >=0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// learn more: https://docs.openzeppelin.com/contracts/3.x/erc20

contract YourToken is ERC20 {

    address private FEaddress = 0xE851e26b3D1578C2E99903b8Ff2487AAdD70528e;

    constructor() ERC20("Gold", "GLD") {
//        _mint(FEaddress, 1000 * 10 ** 18);
        _mint(msg.sender, 1000 * 10 ** 18);
    }
}

pragma solidity >=0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// learn more: https://docs.openzeppelin.com/contracts/3.x/erc20

contract YourToken is ERC20 {

    address private FEaddress = 0x43c0A188E5E4312ef3614916d7d98e046D33188a;

    constructor() ERC20("Gold", "GLD") {
        _mint(FEaddress, 1000 * 10 ** 18);
    }
}

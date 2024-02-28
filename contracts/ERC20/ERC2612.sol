// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "./ERC20Permit.sol";

contract ERC2612 is ERC20, ERC20Permit {
    constructor() ERC20("ERC2612", "MTK") ERC20Permit("ERC2612") {}
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20FlashMint} from "./ERC20FlashMint.sol";

contract MikiToken is ERC20, ERC20FlashMint {
    address public owner;

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }

    constructor() ERC20("MikiToken", "MT") {
        owner = msg.sender;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function _flashFee(
        address,
        uint256 value
    ) internal pure override returns (uint256) {
        return value / 10000;
    }

    function _flashFeeReceiver() internal view override returns (address) {
        return owner;
    }
}

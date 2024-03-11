// SPDX-License-Identifier: MIT

import {IERC3156FlashBorrower} from "./IERC3156FlashBorrower.sol";
import {IERC3156FlashLender} from "./IERC3156FlashLender.sol";

import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";

pragma solidity 0.8.20;

contract FlashBorrower is IERC3156FlashBorrower {
    IERC3156FlashLender lender;

    error ERC3156UntrustedLender(address lender);
    error ERC3156UnrustedInitiator(address initiator);

    event Action1(address borrower, address token, uint256 amount, uint256 fee);

    constructor(IERC3156FlashLender _lender) {
        lender = _lender;
    }

    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external returns (bytes32) {
        if (initiator != address(this)) {
            revert ERC3156UntrustedLender(initiator);
        }

        if (msg.sender != address(lender)) {
            revert ERC3156UntrustedLender(msg.sender);
        }

        uint256 action = abi.decode(data, (uint256));

        if (action == 1) {
            emit Action1(address(this), token, amount, fee);
        } else {
            //
        }

        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }

    function flashBorrow(
        address token,
        uint256 amount,
        bytes memory data
    ) public {
        uint256 _allowance = IERC20(token).allowance(
            address(this),
            address(lender)
        );
        uint256 _fee = lender.flashFee(token, amount);

        uint256 _repayment = amount + _fee;

        IERC20(token).approve(address(lender), _allowance + _repayment);

        lender.flashLoan(lender, token, amount, data);
    }
}

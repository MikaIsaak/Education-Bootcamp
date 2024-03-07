// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Yul {
    // function demo(uint256 a, uint256 b) external pure returns (uint256) {
    //     uint256 result;

    //     assembly {
    //         switch b
    //         case 0 {
    //             result := 0
    //         }
    //         case 1 {
    //             result := a
    //         }
    //         default {
    //             result := div(a, b)
    //         }
    //     }

    //     return result;
    // } Example

    address owner;
    bool called;

    constructor() {
        owner = msg.sender;
    }

    function callMe() external {
        require(owner == msg.sender, "not an owner");

        called = true;
    }

    function prep() external pure returns (bytes memory enc, uint256 len) {
        enc = abi.encode("not an owner");
        len = bytes("not an owner").length;
    }
}

contract YulReal {
    address owner;
    bool called;

    constructor() {
        owner = msg.sender;
    }

    function callMe() external {
        assembly {
            if sub(caller(), sload(owner.slot)) {
                mstore(0x00, 0x20)
                mstore(0x20, 0x0d)
                mstore(
                    0x40,
                    0x6e6f7420616e206f776e65722100000000000000000000000000000000000000
                )
                revert(0x00, 0x60) // from where to start and where to finish
            }
        }

        called = true;
    }

    function set(address _targer, uint256 _a) external {
        // Demo(_targer).callMe(_a);

        assembly {
            mstore(0x00, hex"e73620c3")
            mstore(0x04, _a)

            if iszero(extcodesize(_targer)) {
                revert(0x00, 0x00)
            }

            let success := call(gas(), _targer, 0x00, 0x00, 0x24, 0x00, 0x00)

            if iszero(success) {
                revert(0x00, 0x00)
            }
        }
    }
}

contract Demo {
    uint256 public a;

    /// @notice For testing...
    bool public called;

    function callMe(uint256 _a) external {
        a = _a;
    }

    function demo(address _targer) external {
        require(_targer != address(0), "zero address!");
        called = true;
    }

    function call() external returns (Yul, Yul) {
        bytes memory creationCode = type(Yul).creationCode;

        assembly {
            let c1 := create(0x00, add(0x20, creationCode), mload(creationCode))
            let c2 := create(0x00, add(0x20, creationCode), mload(creationCode))

            if iszero(and(c1, c2)) {
                revert(0x00, 0x00)
            }

            mstore(0x00, c1)
            mstore(0x20, c2)

            return(0x00, 0x40)
        }
    }
}

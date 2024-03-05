// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

library StorageSlot {
    struct AddressSlot {
        address value;
    }

    function getAddressSlot(
        bytes32 _slot
    ) internal pure returns (AddressSlot storage ret) {
        assembly {
            ret.slot := _slot
        }
    }
}

contract Proxy {
    bytes32 private constant IMPLEMENTATION_SLOT =
        bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1); //pre-image

    bytes32 private constant ADMIN_SLOT =
        bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1); //pre-image

    modifier checkAdmin() {
        if (msg.sender == _getAdmin()) {
            _;
        } else {
            _fallback();
        }
    }

    constructor() {
        _setAdmin(msg.sender);
    }

    function upgradeTo(address _implementation) external {
        _setImplementation(_implementation);
    }

    function _fallback() private {
        _delegate(_getImplementation());
    }

    function _delegate(address _implementation) private {
        assembly {
            calldatacopy(0, 0, calldatasize())

            let result := delegatecall(
                gas(),
                _implementation,
                0,
                calldatasize(),
                0,
                0
            )

            returndatacopy(0, 0, returndatasize())

            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    function _getAdmin() private view returns (address) {
        return StorageSlot.getAddressSlot(ADMIN_SLOT).value;
    }

    function _getImplementation() private view returns (address) {
        return StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value;
    }

    function _setAdmin(address _admin) private {
        require(_admin != address(0));

        StorageSlot.getAddressSlot(ADMIN_SLOT).value = _admin;
    }

    function _setImplementation(address _implementation) private {
        StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value = _implementation;
    }

    fallback() external payable {
        _fallback();
    }

    receive() external payable {
        _fallback();
    }
}

/// in case we want to become user of Proxy contract
/// and change implementation using special allocated contract
contract AdminProxy {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function upgrade(
        address payable proxy,
        address implementation
    ) external onlyOwner {
        Proxy(proxy).upgradeTo(implementation);
    }

    function changeProxyAdmin()
}

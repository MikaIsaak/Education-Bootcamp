// SPDX-License-Identifier: MIT

import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

pragma solidity ^0.8.0;

interface IERC721Lazy {
    function redeem(
        address owner,
        address redeemer,
        uint256 tokenId,
        uint256 minPrice,
        string memory uri,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

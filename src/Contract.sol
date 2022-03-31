// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.10 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

/**
 * @dev Implementation of a binary multi-token.
 * See https://eips.ethereum.org/EIPS/eip-1155
 * Originally based on code by OpenZeppelin: https://github.com/OpenZeppelin/openzeppelin-contracts
 *
 * This implementation lets addresses hold a unique instance of multiple tokens,
 * but they cannot have more than one token id
 */
contract BinaryERC1155 is ERC1155 {
    /**
     * @dev See {_setURI}.
     */
    // solhint-disable no-empty-blocks
    constructor(string memory uri_) ERC1155(uri_) {}
}

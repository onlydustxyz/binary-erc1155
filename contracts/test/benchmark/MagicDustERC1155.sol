// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

import "../../BinaryERC1155.sol";

contract MagicDustERC1155 is BinaryERC1155 {
    /* ====== CONSTRUCTOR ====== */

    // solhint-disable no-empty-blocks
    constructor(string memory uri_) BinaryERC1155(uri_) {}

    /* ====== PUBLIC FUNCTIONS ====== */

    function mint(address to_, uint8 id_) public {
        _mint(to_, id_, "");
    }

    function mintBatch(address to_, uint256 packedIds_) public {
        _mintBatch(to_, packedIds_, "");
    }
}

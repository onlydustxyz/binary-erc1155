// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract OpenZeppelinERC1155 is ERC1155 {
    /* ====== CONSTRUCTOR ====== */

    // solhint-disable no-empty-blocks
    constructor(string memory uri_) ERC1155(uri_) {}

    /* ====== PUBLIC FUNCTIONS ====== */

    function mint(address to_, uint8 id_) public {
        _mint(to_, id_, 1, "");
    }

    function mintBatch(
        address to_,
        uint256[] memory ids_,
        uint256[] memory amounts_
    ) public {
        _mintBatch(to_, ids_, amounts_, "");
    }
}

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

import "../BinaryERC1155.sol";

contract SystemUnderTest is BinaryERC1155 {
    // solhint-disable no-empty-blocks
    constructor(string memory uri_) BinaryERC1155(uri_) {}

    function mint(address to_, uint8 id_) public {
        _mint(to_, id_, "");
    }
}

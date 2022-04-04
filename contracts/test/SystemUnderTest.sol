// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

import "../BinaryERC1155.sol";

contract SystemUnderTest is BinaryERC1155 {
    // solhint-disable no-empty-blocks
    constructor(string memory uri_) BinaryERC1155(uri_) {}

    function mint(address to_, uint8 id_) public {
        _mint(to_, id_, "");
    }

    function mintBatch(address to_, uint256 packedIds_) public {
        _mintBatch(to_, packedIds_, "");
    }

    function burn(address from_, uint8 id_) public {
        _burn(from_, id_);
    }

    function burnBatch(address to_, uint256 packedIds_) public {
        _burnBatch(to_, packedIds_);
    }
}

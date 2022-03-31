// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

import "../BinaryERC1155.sol";

contract SystemUnderTest is BinaryERC1155 {
    // solhint-disable no-empty-blocks
    constructor(string memory uri_) BinaryERC1155(uri_) {}

    function unpackNumber(uint256 packedNumber_) public pure returns (uint256[] memory) {
        return _unpackNumber(packedNumber_);
    }
}

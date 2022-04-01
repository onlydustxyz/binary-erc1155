// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

import "ds-test/test.sol";
import "./SystemUnderTest.sol";

contract BinaryERC1155Test is DSTest {
    SystemUnderTest private _sut;

    // solhint-disable no-empty-blocks
    function setUp() public {
        _sut = new SystemUnderTest("");
    }

    function testMinting(uint8 nftType) public {
        assertEq(_sut.balanceOf(msg.sender, nftType), 0);
        _sut.mint(msg.sender, nftType);
        assertEq(_sut.balanceOf(msg.sender, nftType), 1);
    }
}

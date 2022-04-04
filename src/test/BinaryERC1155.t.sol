// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

import "ds-test/test.sol";
import "./SystemUnderTest.sol";
import "../BitOperation.sol";

contract BinaryERC1155Test is DSTest {
    using BitOperation for uint256;

    SystemUnderTest private _sut;

    // solhint-disable no-empty-blocks
    function setUp() public {
        _sut = new SystemUnderTest("");
    }

    function testMinting(uint8 nftType_) public {
        assertEq(_sut.balanceOf(msg.sender, nftType_), 0);
        _sut.mint(msg.sender, nftType_);
        assertEq(_sut.balanceOf(msg.sender, nftType_), 1);
    }

    function testFailMultipleMinting(uint8 nftType_) public {
        _sut.mint(msg.sender, nftType_);
        _sut.mint(msg.sender, nftType_);
    }

    function testBatchMinting(uint256 packedTypes_) public {
        _sut.mintBatch((msg.sender), packedTypes_);

        uint256[] memory types = packedTypes_.unpackIn2Radix();
        for (uint256 i = 0; i < types.length; i++) {
            assertEq(_sut.balanceOf(msg.sender, types[i]), 1);
        }
    }

    function testFailBatchMinting() public {
        uint256 supply = 1024 + 256 + 4;
        _sut.mintBatch(msg.sender, supply);

        uint256 overSupply = 2048 + 256 + 1;
        _sut.mintBatch(msg.sender, overSupply);
    }

    function testBurning(uint8 nftType_) public {
        _sut.mint(msg.sender, nftType_);
        assertEq(_sut.balanceOf(msg.sender, nftType_), 1);
        _sut.burn(msg.sender, nftType_);
        assertEq(_sut.balanceOf(msg.sender, nftType_), 0);
    }

    function testFailBurningNoSupply(uint8 nftType_) public {
        _sut.burn(msg.sender, nftType_);
    }
}

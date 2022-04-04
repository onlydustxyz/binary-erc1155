// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

import "ds-test/test.sol";
import "./SystemUnderTest.sol";
import "../BitOperation.sol";

interface CheatCodes {
    function assume(bool) external;

    function startPrank(address) external;
}

contract BinaryERC1155Test is DSTest {
    using BitOperation for uint256;

    SystemUnderTest private _sut;
    CheatCodes private cheats = CheatCodes(HEVM_ADDRESS);

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
        cheats.assume(packedTypes_ > 0);

        _sut.mintBatch((msg.sender), packedTypes_);

        _assertOwns(msg.sender, packedTypes_, 1);
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

    function testBatchBurning(uint256 packedTypes_) public {
        cheats.assume(packedTypes_ > 0);

        _sut.mintBatch(msg.sender, packedTypes_);
        _sut.burnBatch(msg.sender, packedTypes_);

        _assertOwns(msg.sender, packedTypes_, 0);
    }

    function testFailBatchBurningNoSupply(uint256 packedTypes_) public {
        cheats.assume(packedTypes_ > 0);

        _sut.burnBatch(msg.sender, packedTypes_);
    }

    function testTransfer(uint8 nftType_) public {
        address newOwner = 0x19D1AfF9827034E7d340eC0fc8017c954b197aEE;
        cheats.startPrank(msg.sender);

        _sut.mint(msg.sender, nftType_);
        assertEq(_sut.balanceOf(msg.sender, nftType_), 1);
        assertEq(_sut.balanceOf(newOwner, nftType_), 0);

        _sut.safeTransferFrom(msg.sender, newOwner, nftType_, 1, "");
        assertEq(_sut.balanceOf(msg.sender, nftType_), 0);
        assertEq(_sut.balanceOf(newOwner, nftType_), 1);
    }

    function testFailTransferNoSupply(uint8 nftType_) public {
        address newOwner = 0x19D1AfF9827034E7d340eC0fc8017c954b197aEE;
        cheats.startPrank(msg.sender);

        _sut.safeTransferFrom(msg.sender, newOwner, nftType_, 1, "");
    }

    function testBatchTransfer(uint256 packedTypes_) public {
        cheats.startPrank(msg.sender);

        address newOwner = 0x19D1AfF9827034E7d340eC0fc8017c954b197aEE;
        _sut.mintBatch(msg.sender, packedTypes_);
        _assertOwns(msg.sender, packedTypes_, 1);

        uint256[] memory ids = packedTypes_.unpackIn2Radix();
        uint256[] memory amounts = _arrayOfOnes(ids.length);
        _sut.safeBatchTransferFrom(msg.sender, newOwner, ids, amounts, "");

        _assertOwns(msg.sender, packedTypes_, 0);
        _assertOwns(newOwner, packedTypes_, 1);
    }

    function testBalanceOfBatch() public {
        uint256 packedTypes = 1024 + 16 + 4;
        address[] memory addresses = new address[](2);
        addresses[0] = 0x19D1AfF9827034E7d340eC0fc8017c954b197aEE;
        addresses[1] = 0xAD15376edc4204CEfB4755879FA71c0A1f77Daf5;

        uint256[] memory types = new uint256[](2);
        types[0] = 10;
        types[1] = 4;

        _sut.mintBatch(addresses[0], packedTypes);
        _sut.mintBatch(addresses[1], packedTypes);

        uint256[] memory balances = _sut.balanceOfBatch(addresses, types);

        assertEq(2, balances.length);
        assertEq(1, balances[0]);
        assertEq(1, balances[1]);
    }

    function _assertOwns(
        address owner_,
        uint256 packedTypes_,
        uint8 amount_
    ) internal {
        uint256[] memory types = packedTypes_.unpackIn2Radix();
        for (uint256 i = 0; i < types.length; i++) {
            assertEq(_sut.balanceOf(owner_, types[i]), amount_);
        }
    }

    function _arrayOfOnes(uint256 length_) internal pure returns (uint256[] memory) {
        uint256[] memory result = new uint256[](length_);

        if (length_ != 0) {
            for (uint256 i = 0; i < length_ - 1; ++i) {
                result[i] = 1;
            }
        }

        return result;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

import "./MagicDustERC1155.sol";
import "./OpenZeppelinERC1155.sol";
import "ds-test/test.sol";

interface CheatCodes {
    function assume(bool) external;
}

contract GasBenchmark is DSTest {
    MagicDustERC1155 private _mdErc1155;
    OpenZeppelinERC1155 private _ozErc1155;
    CheatCodes private cheats = CheatCodes(HEVM_ADDRESS);

    function setUp() public {
        _mdErc1155 = new MagicDustERC1155("");
        _ozErc1155 = new OpenZeppelinERC1155("");
    }

    function testMintingGasConsumptionMagicDust(uint8 nftType_) public {
        _mdErc1155.mint(msg.sender, nftType_);
    }

    function testMintingGasConsumptionOpenZeppelin(uint8 nftType_) public {
        _ozErc1155.mint(msg.sender, nftType_);
    }

    function testBatchMintingGasConsumptionMagicDust(uint256 packedIds_) public {
        _mdErc1155.mintBatch(msg.sender, packedIds_);
    }

    function testBatchMintingGasConsumptionOpenZeppelin(uint256[] memory ids_) public {
        cheats.assume(ids_.length < 256);
        uint256[] memory amounts = _arrayOfOnes(ids_.length);

        _ozErc1155.mintBatch(msg.sender, ids_, amounts);
    }

    function _arrayOfOnes(uint256 length_) internal pure returns (uint256[] memory) {
        uint256[] memory result = new uint256[](length_);

        if (length_ != 0) {
            for (uint256 i = 0; i < length_; ++i) {
                result[i] = 1;
            }
        }

        return result;
    }
}

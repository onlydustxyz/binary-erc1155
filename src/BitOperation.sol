// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

/**
 * Bit manipulation made easy on 32 bytes slots represented by bytes32 primitives
 */
library BitOperation {
    function getBit(uint256 input_, uint8 index_) external pure returns (bool) {
        return (input_ & (1 << index_)) != 0;
    }

    function clearBit(uint256 input_, uint8 index_) external pure returns (uint256) {
        return input_ & ~(1 << index_);
    }

    function setBit(uint256 input_, uint8 index_) external pure returns (uint256) {
        return input_ | (1 << index_);
    }

    function matchesMask(uint256 input_, uint256 mask_) external pure returns (bool) {
        return (input_ & mask_) == mask_;
    }
}

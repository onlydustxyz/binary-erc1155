// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

/**
 * Bit manipulation made easy on 32 bytes slots represented by bytes32 primitives
 */
library BitOperation {
    function getBit(uint256 input, uint8 index) external pure returns (bool) {
        return (input & (1 << index)) != 0;
    }

    function clearBit(uint256 input, uint8 index) external pure returns (uint256) {
        return input & ~(1 << index);
    }

    function setBit(uint256 input, uint8 index) external pure returns (uint256) {
        return input | (1 << index);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

import "ds-test/test.sol";
import "../BitOperation.sol";

interface CheatCodes {
    function assume(bool) external;
}

contract BitOperationTest is DSTest {
    using BitOperation for uint256;

    CheatCodes private cheats = CheatCodes(HEVM_ADDRESS);

    function testGetBit() public {
        uint256 oddNumber = 127;
        assertTrue(oddNumber.getBit(0));

        uint256 evenNumber = 128;
        assertTrue(!evenNumber.getBit(0));

        uint256 bigNumber = 1567;
        assertTrue(bigNumber.getBit(0));
        assertTrue(!bigNumber.getBit(5));
        assertTrue(bigNumber.getBit(9));
    }

    function testClearBit(uint256 input_, uint8 bitIndex_) public {
        uint256 clearedNumber = input_.clearBit(bitIndex_);
        if (input_.getBit(bitIndex_)) {
            assertEq(clearedNumber, input_ - 2**bitIndex_);
        } else {
            assertEq(clearedNumber, input_);
        }
    }

    function testSetBit(uint256 input_, uint8 bitIndex_) public {
        if (!input_.getBit(bitIndex_)) {
            // avoid uint256 overflow
            cheats.assume(input_ + 2**bitIndex_ < 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
        }

        uint256 setNumber = input_.setBit(bitIndex_);
        if (input_.getBit(bitIndex_)) {
            assertEq(setNumber, input_);
        } else {
            assertEq(setNumber, input_ + 2**bitIndex_);
        }
    }
}

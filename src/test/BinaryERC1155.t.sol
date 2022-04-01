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

    function testUnpacking() public {
        uint256 packedNumber = 1356;
        uint8[] memory unpackedNumber = _sut.unpackNumber(packedNumber);

        assertEq(unpackedNumber.length, 5);
        assertEq(unpackedNumber[0], 2);
        assertEq(unpackedNumber[1], 3);
        assertEq(unpackedNumber[2], 6);
        assertEq(unpackedNumber[3], 8);
        assertEq(unpackedNumber[4], 10);
    }
}

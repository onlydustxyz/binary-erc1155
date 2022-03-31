// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

/**
 * @dev Implementation of a binary multi-token.
 * See https://eips.ethereum.org/EIPS/eip-1155
 * Originally based on code by OpenZeppelin: https://github.com/OpenZeppelin/openzeppelin-contracts
 *
 * This implementation lets addresses hold a unique instance of multiple tokens,
 * but they cannot have more than one token id
 */
contract BinaryERC1155 is ERC1155 {
    // Mapping from accounts to packed token ids
    mapping(address => uint256) internal _balances;

    // solhint-disable no-empty-blocks
    constructor(string memory uri_) ERC1155(uri_) {}

    /// @notice Gives the balance of the specified token ID for the specified account
    /// @param account_ the account to check the balance for
    /// @param id_ the token ID to check the balance of. Must be less than 256
    /// @return the balance of the token ID for the specified account
    function balanceOf(address account_, uint256 id_) public view virtual override returns (uint256) {
        require(account_ != address(0), "ERC1155: balance query for the zero address");
        require(id_ < 256, "ERC1155: balance query for invalid token id");

        uint256 packedBalance = _balances[account_];

        return (packedBalance / 2**id_) % 2;
    }

    /// @notice Unpack a provided number into its composing powers of 2
    /// @dev Iteratively shift the number's binary representation to the right and check for the result parity
    /// @param packedNumber_ The number to decompose
    /// @return unpackedNumber The array of powers of 2 composing the number
    function _unpackNumber(uint256 packedNumber_) internal pure returns (uint256[] memory unpackedNumber) {
        // solhint-disable no-inline-assembly
        // Assembly is needed here to create a dynamic size array in memory instead of a storage one
        assembly {
            let shiftedInput := packedNumber_
            let currentPowerOf2 := 0
            let unpackingLength := 0

            // solhint-disable no-empty-blocks
            // This for loop is a while loop in disguise
            for {

            } gt(shiftedInput, 0) {
                // Increase the power of 2 by 1 after each iteration
                currentPowerOf2 := add(1, currentPowerOf2)
                // Shift the input to the right by 1
                shiftedInput := shr(1, shiftedInput)
            } {
                // Check if the shifted input is odd
                let parity := mod(shiftedInput, 2)
                if eq(parity, 1) {
                    // The shifter input is odd, let's add this power of 2 to the decomposition array
                    unpackingLength := add(1, unpackingLength)
                    mstore(add(unpackedNumber, mul(unpackingLength, 0x20)), currentPowerOf2)
                }
            }
            // Set the length of the decomposition array
            mstore(unpackedNumber, unpackingLength)
            // Update the free memory pointer according to the decomposition array size
            mstore(0x40, add(unpackedNumber, mul(add(unpackingLength, 1), 0x20)))
        }
    }
}

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./BitOperation.sol";

/**
 * @dev Implementation of a binary multi-token.
 * See https://eips.ethereum.org/EIPS/eip-1155
 * Originally based on code by OpenZeppelin: https://github.com/OpenZeppelin/openzeppelin-contracts
 *
 * This implementation lets addresses hold a unique instance of multiple tokens,
 * but they cannot have more than one token id
 */
contract BinaryERC1155 is ERC1155 {
    using BitOperation for uint256;
    using Address for address;

    // Mapping from accounts to packed token ids
    mapping(address => uint256) private _balances;

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

        return packedBalance.getBit(uint8(id_)) ? 1 : 0;
    }

    /// @notice Mint a new token of a specific id for a given address
    /// @param to_ the address to mint the token for
    /// @param id_ the token ID to mint
    /// @param data_ extra data
    function _mint(
        address to_,
        uint8 id_,
        bytes memory data_
    ) internal virtual {
        _safeTransferFrom(address(0), to_, uint256(id_), 1, data_);
    }

    /// @notice Override OpenZeppelin method and mark it abstract since the amount_
    /// parameter is not releveant in this binary implementation
    function _mint(
        address to_,
        uint256 id_,
        uint256 amount_,
        bytes memory data_
    ) internal virtual override {}

    /// @notice Override OpenZeppelin method
    function _safeTransferFrom(
        address from_,
        address to_,
        uint256 id_,
        uint256 amount_,
        bytes memory data_
    ) internal virtual override {
        require(to_ != address(0), "ERC1155: transfer to the zero address");
        require(id_ < 256, "BinaryERC1155: transfer for invalid token id");
        require(amount_ <= 1, "BinaryERC1155: transfer amount must be less than or equal to 1");

        address operator = _msgSender();
        uint256[] memory ids = _asSingletonArrayCopy(id_);
        uint256[] memory amounts = _asSingletonArrayCopy(amount_);

        _beforeTokenTransfer(operator, from_, to_, ids, amounts, data_);

        // This is a post-minting transfer, let's make some operations on the source address
        if (from_ != address(0)) {
            bool fromOwnsToken = _balances[from_].getBit(uint8(id_));
            require(fromOwnsToken, "ERC1155: insufficient balance for transfer");
            _balances[from_] = _balances[from_].clearBit(uint8(id_));
        }
        _balances[to_] = _balances[to_].setBit(uint8(id_));

        emit TransferSingle(operator, from_, to_, id_, amount_);

        _afterTokenTransfer(operator, from_, to_, ids, amounts, data_);

        _doSafeTransferAcceptanceCheckCopy(operator, from_, to_, id_, amount_, data_);
    }

    /// @notice Unpack a provided number into its composing powers of 2
    /// @dev Iteratively shift the number's binary representation to the right and check for the result parity
    /// @param packedNumber_ The number to decompose
    /// @return unpackedNumber The array of powers of 2 composing the number
    function _unpackNumber(uint256 packedNumber_) internal pure returns (uint8[] memory unpackedNumber) {
        // solhint-disable no-inline-assembly
        // Assembly is needed here to create a dynamic size array in memory instead of a storage one
        assembly {
            let currentPowerOf2 := 0

            // solhint-disable no-empty-blocks
            // This for loop is a while loop in disguise
            for {

            } gt(packedNumber_, 0) {
                // Increase the power of 2 by 1 after each iteration
                currentPowerOf2 := add(1, currentPowerOf2)
                // Shift the input to the right by 1
                packedNumber_ := shr(1, packedNumber_)
            } {
                // Check if the shifted input is odd
                if eq(and(1, packedNumber_), 1) {
                    // The shifter input is odd, let's add this power of 2 to the decomposition array
                    mstore(unpackedNumber, add(1, mload(unpackedNumber)))
                    mstore(add(unpackedNumber, mul(mload(unpackedNumber), 0x20)), currentPowerOf2)
                }
            }
            // Set the length of the decomposition array
            // Update the free memory pointer according to the decomposition array size
            mstore(0x40, add(unpackedNumber, mul(add(1, mload(unpackedNumber)), 0x20)))
        }
    }

    /// @notice copied from OpenZeppelin's _doSafeTransferAcceptanceCheck method
    /// The source function is private and cannot be overriden nor used
    /// we then need to rename it
    function _doSafeTransferAcceptanceCheckCopy(
        address operator,
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) private {
        if (to.isContract()) {
            try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
                if (response != IERC1155Receiver.onERC1155Received.selector) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    }

    /// @notice copied from OpenZeppelin's _asSingletonArray method
    /// The source function is private and cannot be overriden nor used
    /// we then need to rename it
    function _asSingletonArrayCopy(uint256 element) private pure returns (uint256[] memory) {
        uint256[] memory array = new uint256[](1);
        array[0] = element;

        return array;
    }
}

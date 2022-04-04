# Binary ERC1155 implementation

A binary ERC1155 is an ERC1155 where an address can possess a maximum of one instance of a given token id.

## Rationale

The need for this type of ERC1155 comes from the reward logic, where a single address can be given several badges of different types, but only one badge of a given type can be owned at a time.

## Inspiration

This implementation is based on the [OpenZeppelin ERC1155 implementation](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol) and takes advantage of the binary aspect to reduce operations' gas cost.

## Limitations

Due to the internal storage structure, the total number of different token types is limited to 256.

# Installation

## Requirements

- [Foundry](https://github.com/gakonst/foundry) (many thanks to @gakonst for the great work with Foundry)
- [Yarn](https://yarnpkg.com/)

## Install

- `yarn`

# Testing

- `yarn test`

# Benchmark

- `yarn gas-benchmark`

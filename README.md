# Binary ERC1155 implementation

A binary ERC1155 is an ERC1155 where an address can possess a maximum of one instance of a given token id.

Given this rule, the batch minting operation consumes on average **12 times less gas** than the general-purpose ERC1155 implementation.

```
[PASS] testBatchMintingGasConsumptionBinary(uint256) (runs: 256, μ: 102289, ~: 61374)
[PASS] testBatchMintingGasConsumptionOpenZeppelin(uint256[]) (runs: 256, μ: 1117223, ~: 635232)
[PASS] testMintingGasConsumptionBinary(uint8) (runs: 256, μ: 35630, ~: 35630)
[PASS] testMintingGasConsumptionOpenZeppelin(uint8) (runs: 256, μ: 31285, ~: 31285)
```

This contract can be used in any context where you want an address to hold a token or not, the classical usecase is for badge rewarding.

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

- `yarn benchmark`

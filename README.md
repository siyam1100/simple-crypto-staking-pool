# Simple Crypto Staking Pool

This repository features a high-quality, flat-structured implementation of a staking contract. It allows users to deposit a specific ERC-20 token and earn rewards proportional to the amount and duration of their stake.

## Features
* **Reward Calculation:** Automatically calculates rewards based on a fixed annual percentage rate (APR).
* **Flexible Staking:** Users can stake, unstake, and claim rewards at any time.
* **Pool Management:** The owner can fund the pool with reward tokens to keep the ecosystem running.
* **ERC-20 Integration:** Works with any standard token (e.g., USDT, LINK, or custom project tokens).

## Getting Started
1. Deploy `StakingPool.sol` with the address of the token you want users to stake.
2. The owner should call `fundRewards` to add tokens for distribution.
3. Users call `stake(amount)` to participate.
4. Users call `claimReward()` or `withdraw()` to get their tokens back with interest.

## License
MIT

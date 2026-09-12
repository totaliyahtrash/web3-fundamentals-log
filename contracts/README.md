# 📜 Smart Contracts: Architecture & Production Patterns

This directory contains production-grade Solidity smart contracts developed throughout the [Cyfrin Updraft](https://updraft.cyfrin.io/) curriculum.

---

## 🏗️ Contracts Architecture & Patterns

```
+---------------------------------------------------------------------------------+
|                               Smart Contract Suite                              |
|                                                                                 |
|  [ Dynamic On-Chain NFT Suite ]                                                 |
|    Base64.sol (Gas-efficient assembly Base64 encoder)                          |
|           ▲                                                                     |
|           │                                                                     |
|    BasicNft.sol (ERC-721 Standard from scratch)                                 |
|           ▲                                                                     |
|           └─── (Inherits) ─── MoodNft.sol (On-Chain Dynamic SVG NFT)            |
|                                                                                 |
|  [ Provably Fair Lottery Suite ]                                                |
|    Chainlink VRF Coordinator (Verifiable Random Function v2.5)                   |
|           ▲                                                                     |
|           │ (Delivers Cryptographic Randomness)                                 |
|    Chainlink Automation (Decentralized Time & State Trigger)                    |
|           ▲                                                                     |
|           │ (Triggers checkUpkeep -> performUpkeep)                             |
|    raffle/Raffle.sol (Autonomous Provably Fair Lottery with Enum State Machine) |
|                                                                                 |
|  [ Oracle & DeFi Crowdfunding Suite ]                                           |
|    AggregatorV3Interface (Chainlink)                                            |
|           ▲                                                                     |
|           │ (Queries ETH/USD Price)                                             |
|    PriceConverter.sol (Library: using PriceConverter for uint256)               |
|           ▲                                                                     |
|           │ (Price calculations & conversion rates)                             |
|    FundMe.sol (Crowdfunding with Custom Errors & Gas-Optimized Memory Caching)   |
|                                                                                 |
|  [ Token Standards Suite ]                                                      |
|    tokens/ManualToken.sol (EIP-20 Standard from scratch with custom errors)     |
|                                                                                 |
|  [ Foundational Storage Suite ]                                                 |
|    SimpleStorage.sol  <─── (Inherits) ───  AddFiveStorage.sol                   |
|           ▲                                                                     |
|           └────────── (Deploys & Calls) ─── StorageFactory.sol                  |
+---------------------------------------------------------------------------------+
```

---

## 📄 File Summaries

### 1. [`nfts/MoodNft.sol`](./nfts/MoodNft.sol) & [`nfts/BasicNft.sol`](./nfts/BasicNft.sol)
- **Dynamic On-Chain SVG Artwork**: Encodes raw SVG vector graphics and JSON metadata directly into Base64 strings without IPFS or external servers.
- **ERC-721 Standard from Scratch**: Implements token ownership, balances, approvals, and dynamic metadata lookups.
- **State Manipulation**: Interactive `flipMood(tokenId)` allowing owners to toggle the rendered on-chain artwork between HAPPY 😊 and SAD 😢 states.

### 2. [`raffle/Raffle.sol`](./raffle/Raffle.sol)
- **Provably Fair Lottery**: Guarantees unbiasable winner selection using **Chainlink VRF v2.5**.
- **Decentralized Automation**: Integrates **Chainlink Automation** (`checkUpkeep` & `performUpkeep`) with an `enum RaffleState { OPEN, CALCULATING }` state machine.

### 3. [`FundMe.sol`](./FundMe.sol)
- **Decentralized Crowdfunding**: Accepts native ETH contributions with a minimum constraint enforced in USD ($5 USD).
- **Gas Optimization Patterns**: `constant`, `immutable`, Custom Errors (EIP-838), and memory-caching (`cheaperWithdraw`).

### 4. [`tokens/ManualToken.sol`](./tokens/ManualToken.sol)
- **EIP-20 Token Standard From Scratch**: Complete implementation of ERC-20 mechanics (`transfer`, `approve`, `transferFrom`, `allowance`, `balanceOf`).

# 📜 Smart Contracts: Architecture & Production Patterns

This directory contains production-grade Solidity smart contracts developed throughout the [Cyfrin Updraft](https://updraft.cyfrin.io/) curriculum.

---

## 🏗️ Contracts Architecture & Patterns

```
+---------------------------------------------------------------------------------+
|                               Smart Contract Suite                              |
|                                                                                 |
|  [ DeFi: Constant Product AMM DEX ]                                             |
|    defi/CPAMM.sol (x * y = k Invariant, Swaps, 0.3% LP Fees, Liquidity Pools)   |
|                                                                                 |
|  [ DeFi: Decentralized Stablecoin Protocol (DSC) ]                              |
|    AggregatorV3Interface (WETH/USD & WBTC/USD Feeds)                             |
|           ▲                                                                     |
|           │                                                                     |
|    defi/DSCEngine.sol (Collateral, Health Factors, Liquidations, Mint/Burn)     |
|           │                                                                     |
|           ▼ (Mints / Burns pegged $1.00 USD Stablecoin)                         |
|    defi/DecentralizedStableCoin.sol                                             |
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
|    PriceConverter.sol (Library: using PriceConverter for uint256)               |
|           ▲                                                                     |
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

### 1. [`defi/CPAMM.sol`](./defi/CPAMM.sol)
- **Constant Product Automated Market Maker (Uniswap v2 Invariant)**:
  - Preserves $(x + \Delta x \cdot 0.997) \cdot (y - \Delta y) = k$.
  - Liquidity management: geometric mean share minting $\sqrt{x \cdot y}$ on genesis deposit and proportional shares on expansion.
  - Proportional liquidity redemption burning LP shares.

### 2. [`defi/DSCEngine.sol`](./defi/DSCEngine.sol) & [`defi/DecentralizedStableCoin.sol`](./defi/DecentralizedStableCoin.sol)
- **Decentralized Algorithmic Stablecoin ($1.00 USD Peg)** with 200% overcollateralization and liquidations.

### 3. [`nfts/MoodNft.sol`](./nfts/MoodNft.sol) & [`nfts/BasicNft.sol`](./nfts/BasicNft.sol)
- **Dynamic On-Chain SVG Artwork** with Base64 encoding.

### 4. [`raffle/Raffle.sol`](./raffle/Raffle.sol)
- **Provably Fair Lottery** using Chainlink VRF v2.5 and Chainlink Automation.

### 5. [`FundMe.sol`](./FundMe.sol) & [`tokens/ManualToken.sol`](./tokens/ManualToken.sol)
- Crowdfunding oracle contract and native ERC-20 implementation.

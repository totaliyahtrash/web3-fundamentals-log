# 📜 Smart Contracts: Architecture & Production Patterns

This directory contains production-grade Solidity smart contracts developed throughout the [Cyfrin Updraft](https://updraft.cyfrin.io/) curriculum.

---

## 🏗️ Contracts Architecture & Patterns

```
+---------------------------------------------------------------------------------+
|                               Smart Contract Suite                              |
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

### 1. [`defi/DSCEngine.sol`](./defi/DSCEngine.sol) & [`defi/DecentralizedStableCoin.sol`](./defi/DecentralizedStableCoin.sol)
- **Decentralized Algorithmic Stablecoin ($1.00 USD Peg)**:
  - **Exogenous Multi-Collateral**: Backed by WETH and WBTC.
  - **Overcollateralization Guard**: Minimum 200% collateralization required (50% liquidation threshold).
  - **Health Factor Mathematical Engine**: 
    $$\text{Health Factor} = \frac{\text{Collateral Value in USD} \times 50\%}{\text{Total DSC Minted}}$$
  - **Permissionless Liquidations**: If Health Factor $< 1.0$, external liquidators burn DSC debt to seize the borrower's collateral with a $10\%$ liquidation bonus.

### 2. [`nfts/MoodNft.sol`](./nfts/MoodNft.sol) & [`nfts/BasicNft.sol`](./nfts/BasicNft.sol)
- **Dynamic On-Chain SVG Artwork**: Encodes raw SVG vector graphics and JSON metadata directly into Base64 strings without IPFS or external servers.

### 3. [`raffle/Raffle.sol`](./raffle/Raffle.sol)
- **Provably Fair Lottery**: Guarantees unbiasable winner selection using **Chainlink VRF v2.5** and **Chainlink Automation**.

### 4. [`FundMe.sol`](./FundMe.sol)
- **Decentralized Crowdfunding**: Accepts native ETH contributions with a minimum USD constraint, custom errors, and memory caching (`cheaperWithdraw`).

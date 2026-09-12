# 📜 Smart Contracts: Architecture & Production Patterns

This directory contains production-grade Solidity smart contracts developed throughout the [Cyfrin Updraft](https://updraft.cyfrin.io/) curriculum.

---

## 🏗️ Contracts Architecture & Patterns

```
+---------------------------------------------------------------------------------+
|                               Smart Contract Suite                              |
|                                                                                 |
|  [ Cryptographic Airdrops Suite ]                                               |
|    airdrops/MerkleProof.sol (Commutative Sorted Merkle Proof Verifier)          |
|           ▲                                                                     |
|           │ (Verifies O(log N) Membership Proofs)                               |
|    airdrops/MerkleAirdrop.sol (O(1) Storage Gas-Efficient Token Distributor)    |
|                                                                                 |
|  [ Smart Contract Upgradeability Suite ]                                        |
|    upgrades/ERC1967Proxy.sol (Standardized Storage Slot Delegatecall Proxy)     |
|           │ (Delegatecall dispatching)                                          |
|           ├──► upgrades/BoxV1.sol (Initial logic & storage layout: version 1.0) |
|           └──► upgrades/BoxV2.sol (Upgraded logic + increment(): version 2.0)   |
|                                                                                 |
|  [ DeFi: Constant Product AMM DEX ]                                             |
|    defi/CPAMM.sol (x * y = k Invariant, Swaps, 0.3% LP Fees, Liquidity Pools)   |
|                                                                                 |
|  [ DeFi: Decentralized Stablecoin Protocol (DSC) ]                              |
|    fundme/PriceConverter.sol (Chainlink AggregatorV3Interface Queries)          |
|           ▲                                                                     |
|           │                                                                     |
|    defi/DSCEngine.sol (Collateral, Health Factors, Liquidations, Mint/Burn)     |
|           │                                                                     |
|           ▼ (Mints / Burns pegged $1.00 USD Stablecoin)                         |
|    defi/DecentralizedStableCoin.sol                                             |
|                                                                                 |
|  [ Dynamic On-Chain NFT Suite ]                                                 |
|    nfts/Base64.sol (Gas-efficient assembly Base64 encoder)                      |
|           ▲                                                                     |
|           │                                                                     |
|    nfts/BasicNft.sol (ERC-721 Standard from scratch)                            |
|           ▲                                                                     |
|           └─── (Inherits) ─── nfts/MoodNft.sol (On-Chain Dynamic SVG NFT)       |
|                                                                                 |
|  [ Provably Fair Lottery Suite ]                                                |
|    mocks/MockVRFCoordinator.sol (Verifiable Random Function v2.5 Mock)          |
|           ▲                                                                     |
|           │ (Delivers Cryptographic Randomness)                                 |
|    raffle/Raffle.sol (Autonomous Provably Fair Lottery with Enum State Machine) |
|                                                                                 |
|  [ Oracle & DeFi Crowdfunding Suite ]                                           |
|    fundme/PriceConverter.sol (Library: using PriceConverter for uint256)        |
|           ▲                                                                     |
|    fundme/FundMe.sol (Crowdfunding with Custom Errors & Memory Caching)         |
|                                                                                 |
|  [ Token Standards Suite ]                                                      |
|    tokens/ManualToken.sol (EIP-20 Standard from scratch with custom errors)     |
|                                                                                 |
|  [ Foundational Storage Suite ]                                                 |
|    storage/SimpleStorage.sol  <─── (Inherits) ───  storage/AddFiveStorage.sol   |
|           ▲                                                                     |
|           └────────── (Deploys & Calls) ─── storage/StorageFactory.sol          |
+---------------------------------------------------------------------------------+
```

---

## 📂 Domain Breakdown

| Module | File(s) | Description & Key Patterns |
|---|---|---|
| **Storage** | `storage/SimpleStorage.sol`, `storage/StorageFactory.sol`, `storage/AddFiveStorage.sol` | State variables, structs, mappings, arrays, Factory pattern (`new`), and OOP inheritance (`virtual`/`override`). |
| **Crowdfunding** | `fundme/FundMe.sol`, `fundme/PriceConverter.sol` | Chainlink Price Feed oracle, custom errors (EIP-838), immutable state, and `cheaperWithdraw()` memory-caching. |
| **Tokens** | `tokens/ManualToken.sol` | Full EIP-20 standard from scratch: balances, allowances, and custom errors. |
| **Lottery** | `raffle/Raffle.sol` | Provably fair lottery with Chainlink VRF v2.5 and Chainlink Automation state machine. |
| **NFTs** | `nfts/BasicNft.sol`, `nfts/MoodNft.sol`, `nfts/Base64.sol` | ERC-721 token standard & dynamic on-chain SVG artwork with assembly Base64 encoding. |
| **DeFi Stablecoin** | `defi/DSCEngine.sol`, `defi/DecentralizedStableCoin.sol` | Multi-collateral 200% overcollateralized stablecoin with liquidation engine and health factor math. |
| **DeFi AMM DEX** | `defi/CPAMM.sol` | Constant Product Automated Market Maker ($x \cdot y = k$) with 0.3% LP fees. |
| **Upgradeability** | `upgrades/ERC1967Proxy.sol`, `upgrades/BoxV1.sol`, `upgrades/BoxV2.sol` | Collision-resistant ERC-1967 proxy with assembly `delegatecall` and state preservation. |
| **Airdrops** | `airdrops/MerkleAirdrop.sol`, `airdrops/MerkleProof.sol` | Cryptographic Merkle Tree airdrop distributor with $O(1)$ storage and $O(\log N)$ proof verification. |
| **Mocks** | `mocks/MockV3Aggregator.sol`, `mocks/MockVRFCoordinator.sol` | Mock oracles for offline Foundry testing. |

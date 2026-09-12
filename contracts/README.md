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
|    ERC1967Proxy.sol (Standardized Storage Slot Delegatecall Proxy)              |
|           │ (Delegatecall dispatching)                                          |
|           ├──► upgrades/BoxV1.sol (Initial logic & storage layout: version 1.0) |
|           └──► upgrades/BoxV2.sol (Upgraded logic + increment(): version 2.0)   |
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

### 1. [`airdrops/MerkleAirdrop.sol`](./airdrops/MerkleAirdrop.sol) & [`airdrops/MerkleProof.sol`](./airdrops/MerkleProof.sol)
- **Cryptographic Merkle Airdrop**:
  - Replaces massive $O(N)$ whitelist storage mappings with a single 32-byte Merkle root ($O(1)$ on-chain storage).
  - Users provide a cryptographic branch path (`merkleProof`) verified in $O(\log N)$ hashing steps.
  - Double-hashed leaf construction (`keccak256(bytes.concat(keccak256(abi.encode(...))))`) and sorted commutative pair hashing to protect against second-preimage attacks.

### 2. [`upgrades/ERC1967Proxy.sol`](./upgrades/ERC1967Proxy.sol), [`upgrades/BoxV1.sol`](./upgrades/BoxV1.sol), [`upgrades/BoxV2.sol`](./upgrades/BoxV2.sol)
- **ERC-1967 Upgradeable Proxies**: Collision-resistant unassigned storage slots and assembly `delegatecall`.

### 3. [`defi/CPAMM.sol`](./defi/CPAMM.sol)
- **Constant Product Automated Market Maker (Uniswap v2 Invariant)**: $(x + \Delta x \cdot 0.997) \cdot (y - \Delta y) = k$.

### 4. [`defi/DSCEngine.sol`](./defi/DSCEngine.sol) & [`defi/DecentralizedStableCoin.sol`](./defi/DecentralizedStableCoin.sol)
- **Decentralized Algorithmic Stablecoin ($1.00 USD Peg)** with 200% overcollateralization and liquidations.

### 5. [`nfts/MoodNft.sol`](./nfts/MoodNft.sol) & [`nfts/BasicNft.sol`](./nfts/BasicNft.sol)
- **Dynamic On-Chain SVG Artwork** with Base64 encoding.

### 6. [`raffle/Raffle.sol`](./raffle/Raffle.sol)
- **Provably Fair Lottery** using Chainlink VRF v2.5 and Chainlink Automation.

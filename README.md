# ⛓️ Web3 Fundamentals Log

> A comprehensive, production-grade engineering log of my journey into Ethereum, EVM internals, Account Abstraction (ERC-4337), Smart Contract Upgradeability (ERC-1967 Proxies), AMM Decentralized Exchanges (CPAMM), DeFi Stablecoins (DSC Engine), Dynamic On-Chain NFTs (ERC-721), Provably Fair Lotteries (Chainlink VRF & Automation), Token Standards (ERC-20), and automated Foundry Testing through the [Cyfrin Updraft](https://updraft.cyfrin.io/) curriculum.

[![Course](https://img.shields.io/badge/Course-Cyfrin%20Updraft-blue?style=flat-square)](https://updraft.cyfrin.io/)
[![Solidity](https://img.shields.io/badge/Solidity-%5E0.8.19-363636?style=flat-square&logo=solidity)](contracts/)
[![Foundry](https://img.shields.io/badge/Framework-Foundry-red?style=flat-square&logo=ethereum)](test/)
[![Proxies](https://img.shields.io/badge/Pattern-ERC--1967%20Upgradeable%20Proxies-blueviolet?style=flat-square)](contracts/upgrades/ERC1967Proxy.sol)
[![DEX AMM](https://img.shields.io/badge/DeFi-Constant%20Product%20AMM%20(DEX)-blue?style=flat-square)](contracts/defi/CPAMM.sol)
[![DeFi Protocol](https://img.shields.io/badge/DeFi-Decentralized%20Stablecoin%20(DSC)-gold?style=flat-square)](contracts/defi/DSCEngine.sol)
[![NFTs](https://img.shields.io/badge/Standard-ERC--721%20On--Chain%20SVG-green?style=flat-square)](contracts/nfts/MoodNft.sol)
[![Chainlink VRF](https://img.shields.io/badge/Chainlink-VRF%20v2.5%20%26%20Automation-375BD2?style=flat-square&logo=chainlink&logoColor=white)](contracts/raffle/Raffle.sol)
[![ERC-20](https://img.shields.io/badge/Standard-ERC--20-purple?style=flat-square)](contracts/tokens/ManualToken.sol)
[![Account Abstraction](https://img.shields.io/badge/Standard-ERC--4337-orange?style=flat-square)](notes/wallets-and-account-abstraction.md)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)

---

## 🎯 About This Repository

Welcome! I am an aspiring Web3 & Smart Contract Engineer documenting my rigorous technical journey from core cryptographic principles to composable on-chain architectures.

Rather than passive video watching, this repository acts as my **verifiable proof of work**. It includes:
- **Production Smart Contracts**:
  - `ERC1967Proxy.sol`, `BoxV1.sol` & `BoxV2.sol`: Upgradeable proxy patterns using ERC-1967 pseudo-random storage slots and assembly `delegatecall`.
  - `CPAMM.sol`: Constant Product Automated Market Maker DEX with $x \cdot y = k$ invariant pricing, 0.3% liquidity pool fees, and LP share minting/burning.
  - `DSCEngine.sol` & `DecentralizedStableCoin.sol`: Algorithmic overcollateralized stablecoin engine with Chainlink price feeds, health factor monitoring, and liquidation mechanics.
  - `MoodNft.sol` & `BasicNft.sol`: Fully on-chain dynamic SVG NFTs encoding graphics into Base64 with interactive state toggling.
  - `Raffle.sol`: Provably fair lottery governed by **Chainlink VRF v2.5** and autonomous **Chainlink Automation** with an enum state machine.
  - `FundMe.sol`: DeFi crowdfunding with **Chainlink Price Feeds**, custom errors, immutable state, and memory caching (`cheaperWithdraw`).
  - `ManualToken.sol`: Full **EIP-20** token standard implementation from scratch.
  - `StorageFactory.sol` & `AddFiveStorage.sol`: On-chain factory deployment and OOP inheritance.
- **Foundry Unit Testing & Deployment**: Comprehensive Forge test suites (`test/UpgradeTest.t.sol`, `test/CPAMMTest.t.sol`, `test/DSCEngineTest.t.sol`, `test/NftTest.t.sol`, `test/RaffleTest.t.sol`, `test/FundMeTest.t.sol`, `test/ManualTokenTest.t.sol`) with cheatcodes (`vm.warp`, `vm.roll`, `vm.prank`, `vm.deal`, `vm.expectRevert`).
- **Comprehensive Technical Guides**: In-depth analysis of Wallets (EOA vs. Smart Account ERC-4337, MPC, Multisig), Layer 2 Rollups (Optimistic vs. ZK), EIP-4844 Blobs, and MEV dynamics.
- **Developer CLI Utilities**: Standalone Python tooling (`scripts/evm_inspector.py`) to simulate EIP-1559 base fee burns, calculate L2 rollup execution/blob fees, and compute mempool speed-up gas requirements.

---

## 🧭 Master Learning Roadmap & Progress Checklist

- [x] **Module 1: Blockchain & Distributed Ledger Architecture**
  - [x] Decentralization, Byzantine Fault Tolerance & consensus (PoW vs. PoS / Gasper)
  - [x] Cryptographic hashing mechanics (SHA-256 vs. Keccak-256, collision/pre-image resistance)
  - [x] The EVM State Machine (World State, Storage Slots, CodeHash, Nonces)
- [x] **Module 2: Advanced Wallets & Account Abstraction (ERC-4337)**
  - [x] BIP-39 mnemonic seed phrases & BIP-32/44 HD derivation paths (`m/44'/60'/0'/0/x`)
  - [x] Elliptic curve keypairs (`secp256k1` $k \rightarrow K = k \times G \rightarrow \text{Address}$)
  - [x] Wallet classification: Hot vs. Hardware (Secure Element) vs. Multi-Sig (Safe) vs. MPC
  - [x] Account Abstraction (ERC-4337): UserOperations, Bundlers, EntryPoint, and Paymasters
- [x] **Module 3: Networks, Testnets & Layer 2 Rollups**
  - [x] Network hierarchy: Ethereum Mainnet vs. Sepolia (`11155111`) vs. Holesky (`17000`)
  - [x] Layer 2 Scaling: Optimistic Rollups (Arbitrum/Optimism) vs. ZK-Rollups (zkSync/Scroll)
  - [x] Data Availability & EIP-4844 Proto-Danksharding (Blob gas mechanics)
  - [x] JSON-RPC 2.0 interface (`eth_call`, `eth_sendRawTransaction`, `eth_estimateGas`)
- [x] **Module 4: Mempool Dynamics, MEV & Transaction Lifecycles**
  - [x] EIP-1559 fee formula: $\text{Gas Fee} = \text{Gas Used} \times (\text{Base Fee} + \text{Priority Fee})$
  - [x] Nonce management, transaction replacement (+12% speed-up), and zero-value cancellation
  - [x] Maximal Extractable Value (MEV): Frontrunning, Sandwich attacks, and Flashbots Protect
  - [x] Cross-chain replay protection via EIP-155 ($v = 2 \times \text{ChainId} + 35 + \text{recoveryBit}$)
- [x] **Module 5: Solidity Architecture & Design Patterns**
  - [x] `SimpleStorage.sol` (state variables, structs, mappings, arrays, events, `calldata` vs `memory`)
  - [x] `StorageFactory.sol` (Factory Pattern & contract composability using `new`)
  - [x] `AddFiveStorage.sol` (OOP inheritance, polymorphism, `virtual` and `override` functions)
- [x] **Module 6: Advanced Solidity & Chainlink Oracles (`FundMe.sol`)**
  - [x] `PriceConverter.sol` (Solidity Library & Chainlink `AggregatorV3Interface` oracle integration)
  - [x] `FundMe.sol` (Decentralized crowdfunding, minimum USD threshold via oracle)
  - [x] Gas Optimizations: `immutable`, `constant`, Custom Errors (EIP-838), and memory caching (`cheaperWithdraw()`)
- [x] **Module 7: ERC-20 Token Standard From Scratch (`ManualToken.sol`)**
  - [x] Complete EIP-20 standard: balances, allowances, transfers, custom errors
- [x] **Module 8: Provably Fair Smart Contract Lottery (`Raffle.sol`)**
  - [x] Chainlink VRF v2.5 integration for unbiasable, on-chain verifiable randomness
  - [x] Chainlink Automation (`checkUpkeep` & `performUpkeep`) for autonomous execution
  - [x] Enum State Machine (`RaffleState { OPEN, CALCULATING }`)
- [x] **Module 9: Dynamic On-Chain SVG NFTs (`MoodNft.sol`)**
  - [x] ERC-721 standard implementation from scratch (`BasicNft.sol`)
  - [x] Fully on-chain Base64 metadata encoding without IPFS/cloud hosting
  - [x] Dynamic state manipulation: Owner-controlled mood flipping (Happy $\leftrightarrow$ Sad)
- [x] **Module 10: DeFi Overcollateralized Stablecoin Engine (`DSCEngine.sol`)**
  - [x] Multi-collateral exogenous backing (WETH / WBTC)
  - [x] Chainlink Price Feed valuation & 200% Overcollateralization health factor engine
  - [x] Permissionless liquidation engine with 10% bonus incentive for liquidators
- [x] **Module 11: Constant Product Automated Market Maker DEX (`CPAMM.sol`)**
  - [x] Uniswap v2 core math: $(x + \Delta x \cdot 0.997) \cdot (y - \Delta y) = x \cdot y$
  - [x] Liquidity provisioning, geometric mean share minting $\sqrt{x \cdot y}$, and burning
- [x] **Module 12: Smart Contract Upgradeability & Proxies (ERC-1967)**
  - [x] Storage collision prevention with standardized slots (`keccak256("eip1967.proxy.implementation") - 1`)
  - [x] Assembly `delegatecall` dispatcher and state preservation validation across version upgrades
- [x] **Module 13: Comprehensive Foundry Testing & Deployment**
  - [x] Forge unit tests: `UpgradeTest.t.sol`, `CPAMMTest.t.sol`, `DSCEngineTest.t.sol`, `NftTest.t.sol`, `RaffleTest.t.sol`, `FundMeTest.t.sol`, `ManualTokenTest.t.sol`

---

## 🏗️ Smart Contracts Architecture

Located in [`/contracts`](contracts/):

```
+---------------------------------------------------------------------------------+
|                               Smart Contract Suite                              |
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

## 🧪 Foundry Automated Testing & Deployment

```bash
# Run all unit tests across all suites
forge test

# Run tests for Upgradeable Proxies
forge test --match-contract UpgradeTest -vvv

# Run tests for Constant Product AMM DEX
forge test --match-contract CPAMMTest -vvv

# Run tests for the DeFi Stablecoin Engine
forge test --match-contract DSCEngineTest -vvv

# Run tests for Dynamic SVG NFTs
forge test --match-contract NftTest -vvv

# Run tests for Raffle with execution traces
forge test --match-contract RaffleTest -vvvv

# Run gas snapshot analysis
forge snapshot
```

---

## 📂 Repository Structure

```text
web3-fundamentals-log/
├── README.md                                     # Master documentation, architecture & roadmap
├── LICENSE                                       # Open-source MIT License
├── foundry.toml                                  # Foundry framework configuration
├── .gitignore                                    # Strict secret and environment ignore rules
├── contracts/
│   ├── README.md                                 # Full architecture & deployment guide
│   ├── upgrades/
│   │   ├── ERC1967Proxy.sol                      # Collision-resistant delegatecall proxy
│   │   ├── BoxV1.sol                             # Initial logic implementation (v1.0.0)
│   │   └── BoxV2.sol                             # Upgraded implementation (v2.0.0 + increment)
│   ├── defi/
│   │   ├── CPAMM.sol                             # Constant Product Automated Market Maker DEX
│   │   ├── DSCEngine.sol                         # Core DeFi collateral & liquidation engine
│   │   └── DecentralizedStableCoin.sol           # Algorithmic pegged ERC-20 stablecoin
│   ├── nfts/
│   │   ├── Base64.sol                            # Assembly-level Base64 string encoder
│   │   ├── BasicNft.sol                          # ERC-721 token standard from scratch
│   │   └── MoodNft.sol                           # Dynamic on-chain SVG NFT with state flipping
│   ├── raffle/
│   │   └── Raffle.sol                            # Provably fair lottery with VRF & Automation
│   ├── FundMe.sol                                # Crowdfunding with Chainlink & gas patterns
│   ├── PriceConverter.sol                        # Library for Chainlink AggregatorV3Interface
│   ├── SimpleStorage.sol                         # Base storage contract (structs, mappings, arrays)
│   ├── StorageFactory.sol                        # Factory Pattern & contract composability
│   ├── AddFiveStorage.sol                        # OOP Inheritance & function overriding
│   ├── tokens/
│   │   └── ManualToken.sol                       # ERC-20 Token Standard from scratch
│   └── mocks/
│       ├── MockVRFCoordinator.sol                # Mock Chainlink VRF for local testing
│       └── MockV3Aggregator.sol                  # Mock Chainlink Price Feed for local testing
├── test/
│   ├── TestHelpers.sol                           # Minimal Forge VM cheatcode interface
│   ├── UpgradeTest.t.sol                         # Automated unit tests for ERC-1967 Proxies
│   ├── CPAMMTest.t.sol                           # Automated unit tests for AMM DEX
│   ├── DSCEngineTest.t.sol                       # Automated unit tests for DeFi DSC Protocol
│   ├── NftTest.t.sol                             # Automated unit tests for ERC-721 and Mood NFT
│   ├── RaffleTest.t.sol                          # Automated unit tests for Raffle & VRF
│   ├── FundMeTest.t.sol                          # Automated unit tests for FundMe
│   └── ManualTokenTest.t.sol                     # Automated unit tests for ManualToken ERC-20
├── script/
│   └── DeployFundMe.s.sol                        # Scripted multi-chain broadcast deployment
├── scripts/
│   └── evm_inspector.py                          # CLI utility for EIP-1559, L2 fees, and speedups
├── activities/
│   └── testnet-transaction-lab.md                # Wallet setup, faucet mechanics & tx dissection lab
└── notes/
    ├── wallets-and-account-abstraction.md        # Cryptography, HD paths, MPC, and ERC-4337
    ├── networks-mainnet-testnets-l2s.md          # L1 vs L2 rollups, EIP-4844 blobs, and JSON-RPC
    ├── advanced-transaction-mechanics-and-mev.md # Mempool lifecycle, MEV attacks, and EIP-155
    └── blockchain-fundamentals.md                # Consensus, Keccak-256, and EVM state
```

---

## 🤝 Connect & Acknowledgments

- **Learner**: [totaliyahtrash](https://github.com/totaliyahtrash)
- **Learning Resource**: Built while mastering the [Cyfrin Updraft](https://updraft.cyfrin.io/) curriculum by [Patrick Collins](https://github.com/PatrickAlphaC).

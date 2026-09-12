# ⛓️ Web3 Fundamentals Log

> A comprehensive, production-grade engineering log of my journey into Ethereum, EVM internals, Account Abstraction (ERC-4337), Provably Fair Lotteries (Chainlink VRF & Automation), Token Standards (ERC-20), Layer 2 scaling, and automated Foundry Testing through the [Cyfrin Updraft](https://updraft.cyfrin.io/) curriculum.

[![Course](https://img.shields.io/badge/Course-Cyfrin%20Updraft-blue?style=flat-square)](https://updraft.cyfrin.io/)
[![Solidity](https://img.shields.io/badge/Solidity-%5E0.8.19-363636?style=flat-square&logo=solidity)](contracts/)
[![Foundry](https://img.shields.io/badge/Framework-Foundry-red?style=flat-square&logo=ethereum)](test/)
[![Chainlink VRF](https://img.shields.io/badge/Chainlink-VRF%20v2.5%20%26%20Automation-375BD2?style=flat-square&logo=chainlink&logoColor=white)](contracts/raffle/Raffle.sol)
[![ERC-20](https://img.shields.io/badge/Standard-ERC--20-blueviolet?style=flat-square)](contracts/tokens/ManualToken.sol)
[![Account Abstraction](https://img.shields.io/badge/Standard-ERC--4337-orange?style=flat-square)](notes/wallets-and-account-abstraction.md)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)

---

## 🎯 About This Repository

Welcome! I am an aspiring Web3 & Smart Contract Engineer documenting my rigorous technical journey from core cryptographic principles to composable on-chain architectures.

Rather than passive video watching, this repository acts as my **verifiable proof of work**. It includes:
- **Production Smart Contracts**:
  - `Raffle.sol`: Provably fair lottery governed by **Chainlink VRF v2.5** and autonomous **Chainlink Automation** with an enum state machine.
  - `FundMe.sol`: DeFi crowdfunding with **Chainlink Price Feeds**, custom errors, immutable state, and memory caching (`cheaperWithdraw`).
  - `ManualToken.sol`: Full **EIP-20** token standard implementation from scratch.
  - `StorageFactory.sol` & `AddFiveStorage.sol`: On-chain factory deployment and OOP inheritance.
- **Foundry Unit Testing & Deployment**: Comprehensive Forge test suites (`test/RaffleTest.t.sol`, `test/FundMeTest.t.sol`, `test/ManualTokenTest.t.sol`) with time-travel cheatcodes (`vm.warp`, `vm.roll`, `vm.prank`, `vm.deal`, `vm.expectRevert`).
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
- [x] **Module 9: Foundry Automated Testing & Deployment**
  - [x] Unit test suites with Forge: `RaffleTest.t.sol`, `FundMeTest.t.sol`, `ManualTokenTest.t.sol`
  - [x] VM Cheatcodes: `vm.warp`, `vm.roll`, `vm.prank`, `vm.deal`, `vm.expectRevert`

---

## 🏗️ Smart Contracts Architecture

Located in [`/contracts`](contracts/):

```
+---------------------------------------------------------------------------------+
|                               Smart Contract Suite                              |
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

## 🧪 Foundry Automated Testing & Deployment

```bash
# Run all unit tests
forge test

# Run tests for Raffle with detailed execution traces
forge test --match-contract RaffleTest -vvvv

# Run gas snapshot analysis
forge snapshot
```

---

## 🛠️ Developer Tooling: `evm_inspector.py`

Located in [`scripts/evm_inspector.py`](scripts/evm_inspector.py), this zero-dependency Python utility provides instant EVM calculations:

```bash
# Calculate EIP-1559 L1 fee breakdown (burned fee vs. validator tip)
python scripts/evm_inspector.py --calc-fee --gas 21000 --base-fee 18.5 --priority-fee 1.5

# Calculate Layer 2 Rollup transaction fee (L2 execution + L1 calldata/blob cost)
python scripts/evm_inspector.py --l2-fee --l2-gas 50000 --l2-gas-price 0.01 --calldata-bytes 128
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

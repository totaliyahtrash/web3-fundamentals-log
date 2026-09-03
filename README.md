# ⛓️ Web3 Fundamentals Log

> A comprehensive, production-grade engineering log of my journey into Ethereum, EVM internals, Account Abstraction (ERC-4337), Layer 2 scaling, and Smart Contract Architecture through the [Cyfrin Updraft](https://updraft.cyfrin.io/) curriculum.

[![Course](https://img.shields.io/badge/Course-Cyfrin%20Updraft-blue?style=flat-square)](https://updraft.cyfrin.io/)
[![Solidity](https://img.shields.io/badge/Solidity-%5E0.8.19-363636?style=flat-square&logo=solidity)](contracts/)
[![Chainlink](https://img.shields.io/badge/Oracle-Chainlink%20Price%20Feeds-375BD2?style=flat-square&logo=chainlink&logoColor=white)](contracts/PriceConverter.sol)
[![Account Abstraction](https://img.shields.io/badge/Standard-ERC--4337-orange?style=flat-square)](notes/wallets-and-account-abstraction.md)
[![Network](https://img.shields.io/badge/Network-Ethereum%20Sepolia-627EEA?style=flat-square&logo=ethereum&logoColor=white)](activities/testnet-transaction-lab.md)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)

---

## 🎯 About This Repository

Welcome! I am an aspiring Web3 & Smart Contract Engineer documenting my rigorous technical journey from core cryptographic principles to composable on-chain architectures.

Rather than passive video watching, this repository acts as my **verifiable proof of work**. It includes:
- **Production Smart Contracts**: `FundMe.sol` (Chainlink oracles, gas-optimized `cheaperWithdraw()`, custom errors, immutable/constant state), `StorageFactory.sol`, and `AddFiveStorage.sol`.
- **Comprehensive Technical Guides**: In-depth analysis of Wallets (EOA vs. Smart Account ERC-4337, MPC, Multisig), Layer 2 Rollups (Optimistic vs. ZK), EIP-4844 Blobs, and MEV dynamics.
- **Developer CLI Utilities**: Standalone Python tooling (`scripts/evm_inspector.py`) to simulate EIP-1559 base fee burns, calculate L2 rollup execution/blob fees, and compute mempool speed-up gas requirements.
- **Hands-on Transaction Auditing**: Real testnet transaction dissections inspecting gas, nonces, and signature recovery.

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
  - [x] Special Functions: `receive()` and `fallback()` for native ETH transfers
- [ ] **Module 7: Next Step: Foundry Toolkit (Forge, Cast, Anvil)**
  - [ ] Local testing with `forge test`, scripted deployment pipelines, and fuzzing

---

## 🏗️ Smart Contracts Architecture

Located in [`/contracts`](contracts/):

```
+---------------------------------------------------------------------------------+
|                               Smart Contract Suite                              |
|                                                                                 |
|  [ Foundational Storage Suite ]                                                 |
|    SimpleStorage.sol  <─── (Inherits) ───  AddFiveStorage.sol                   |
|           ▲                                                                     |
|           └────────── (Deploys & Calls) ─── StorageFactory.sol                  |
|                                                                                 |
|  [ Oracle & DeFi Crowdfunding Suite ]                                           |
|    AggregatorV3Interface (Chainlink)                                            |
|           ▲                                                                     |
|           │ (Queries ETH/USD Price)                                             |
|    PriceConverter.sol (Library: using PriceConverter for uint256)               |
|           ▲                                                                     |
|           │ (Price calculations & conversion rates)                             |
|    FundMe.sol                                                                   |
|      ├── Custom Errors: `FundMe__NotOwner()`, `FundMe__DidNotSendEnoughETH()`   |
|      ├── Gas Optimizations: `immutable`, `constant`, SLOAD caching in memory    |
|      └── Special Functions: `receive()` & `fallback()` to handle native ETH     |
+---------------------------------------------------------------------------------+
```

1. **[`FundMe.sol`](contracts/FundMe.sol)**: Crowdfunding contract featuring minimum USD checks via Chainlink, custom errors, `immutable`/`constant` variables, and the `cheaperWithdraw()` memory-caching pattern.
2. **[`PriceConverter.sol`](contracts/PriceConverter.sol)**: Reusable library converting ETH amounts to USD using Chainlink `AggregatorV3Interface`.
3. **[`mocks/MockV3Aggregator.sol`](contracts/mocks/MockV3Aggregator.sol)**: Mock price feed enabling zero-cost local testing in Remix & Anvil.
4. **[`SimpleStorage.sol`](contracts/SimpleStorage.sol)**, **[`StorageFactory.sol`](contracts/StorageFactory.sol)**, **[`AddFiveStorage.sol`](contracts/AddFiveStorage.sol)**: Storage primitives, factory deployment patterns, and object-oriented inheritance.

---

## 🛠️ Developer Tooling: `evm_inspector.py`

Located in [`scripts/evm_inspector.py`](scripts/evm_inspector.py), this zero-dependency Python utility provides instant EVM calculations:

```bash
# Calculate EIP-1559 L1 fee breakdown (burned fee vs. validator tip)
python scripts/evm_inspector.py --calc-fee --gas 21000 --base-fee 18.5 --priority-fee 1.5

# Calculate Layer 2 Rollup transaction fee (L2 execution + L1 calldata/blob cost)
python scripts/evm_inspector.py --l2-fee --l2-gas 50000 --l2-gas-price 0.01 --calldata-bytes 128

# Calculate minimum replacement gas to unstick a pending mempool transaction
python scripts/evm_inspector.py --speedup --current-fee 20.0

# Simulate EIP-1559 dynamic base fee escalation across full blocks
python scripts/evm_inspector.py --eip1559-sim --start-fee 20.0 --blocks 5 --fullness 100
```

---

## 📚 Technical Documentation Directory

- **[`notes/wallets-and-account-abstraction.md`](notes/wallets-and-account-abstraction.md)**: Deep dive into BIP-39/44 derivation, private key cryptography, multi-sig vs MPC, and ERC-4337 account abstraction architecture.
- **[`notes/networks-mainnet-testnets-l2s.md`](notes/networks-mainnet-testnets-l2s.md)**: Comprehensive guide to L1 settlement, Sepolia/Holesky testnets, Optimistic vs. ZK Rollups, EIP-4844 blobs, and JSON-RPC node architecture.
- **[`notes/advanced-transaction-mechanics-and-mev.md`](notes/advanced-transaction-mechanics-and-mev.md)**: Detailed transaction lifecycle, MEV (frontrunning, sandwich attacks), EIP-155 replay protection, and mempool nonce handling.
- **[`notes/blockchain-fundamentals.md`](notes/blockchain-fundamentals.md)**: Cryptographic hashing, consensus mechanisms, and EVM state transition rules.
- **[`activities/testnet-transaction-lab.md`](activities/testnet-transaction-lab.md)**: Hands-on developer wallet configuration, faucet liquidity acquisition, and EIP-1559 transaction signature dissection.

---

## 📂 Repository Structure

```text
web3-fundamentals-log/
├── README.md                                     # Main project documentation & proof of work
├── LICENSE                                       # Open-source MIT License
├── .gitignore                                    # Strict secret and environment ignore rules
├── contracts/
│   ├── README.md                                 # Full architecture & Remix deployment guide
│   ├── FundMe.sol                                # Crowdfunding with Chainlink & gas optimizations
│   ├── PriceConverter.sol                        # Library for Chainlink AggregatorV3Interface
│   ├── SimpleStorage.sol                         # Base storage contract (structs, mappings, arrays)
│   ├── StorageFactory.sol                        # Factory Pattern & contract composability
│   ├── AddFiveStorage.sol                        # OOP Inheritance & function overriding
│   └── mocks/
│       └── MockV3Aggregator.sol                  # Mock Chainlink feed for local testing
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

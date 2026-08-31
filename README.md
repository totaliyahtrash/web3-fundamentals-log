# ⛓️ Web3 Fundamentals Log

> A documented, hands-on learning log of my first steps into Ethereum, Web3 development, and the EVM ecosystem through the [Cyfrin Updraft](https://updraft.cyfrin.io/) curriculum.

[![Course](https://img.shields.io/badge/Course-Cyfrin%20Updraft%20Blockchain%20Basics-blue?style=flat-square)](https://updraft.cyfrin.io/)
[![Solidity](https://img.shields.io/badge/Solidity-%5E0.8.19-363636?style=flat-square&logo=solidity)](contracts/)
[![Network](https://img.shields.io/badge/Network-Ethereum%20Sepolia-627EEA?style=flat-square&logo=ethereum&logoColor=white)](#-testnet-transaction-log)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)

---

## 🎯 About This Repository

Welcome! I am an aspiring Web3 / Smart Contract Developer documenting my fundamentals from day one. 

Rather than treating learning as passive video-watching, this repository serves as my **verifiable proof of work**. It contains:
- **Hands-on Transaction Logs**: Breakdown of transactions broadcasted to Sepolia and virtual testnets.
- **Smart Contract Implementations**: Production-grade commented Solidity code exploring the Factory Pattern, inheritance, and state storage.
- **Developer Utilities**: A custom zero-dependency CLI tool (`scripts/evm_inspector.py`) to simulate EIP-1559 dynamic base fee scaling and precise Wei conversions.
- **Security & Core Theory**: Deep-dive technical notes on EVM state machines, cryptographic keypairs, and wallet isolation.

---

## 🧭 Course Progress Checklist

Tracked progress through the **Cyfrin Updraft** curriculum taught by Patrick Collins:

- [x] **Module 1: What is a Blockchain?**
  - [x] Decentralization, immutability, and distributed ledgers
  - [x] Consensus mechanisms (Proof of Work vs. Proof of Stake)
  - [x] Cryptographic hashing (SHA-256, Keccak-256)
- [x] **Module 2: Wallets, Keys & Security**
  - [x] Asymmetric cryptography (Public Key vs. Private Key)
  - [x] Hierarchical Deterministic (HD) wallets & BIP-39 mnemonic seed phrases
  - [x] Setting up a dedicated burner/developer wallet (Rabby / MetaMask)
- [x] **Module 3: Gas & Transaction Mechanics**
  - [x] EIP-1559 gas model (Base Fee, Priority Fee / Tip, Max Fee)
  - [x] Nonce mechanics and transaction sequencing
  - [x] Transaction lifecycles (Mempool $\rightarrow$ Inclusion $\rightarrow$ Finality)
- [x] **Module 4: Practical Testnet Interaction**
  - [x] Acquiring testnet funds via faucets (Sepolia ETH)
  - [x] Broadcasting native transactions across accounts
  - [x] Inspecting execution on block explorers (Etherscan, Tenderly)
- [x] **Module 5: Solidity Fundamentals & Design Patterns**
  - [x] `SimpleStorage.sol` (state variables, structs, mappings, arrays)
  - [x] `StorageFactory.sol` (Factory Pattern & contract composability)
  - [x] `AddFiveStorage.sol` (inheritance, polymorphism, `override` / `virtual`)
- [ ] **Module 6: Foundry Fundamentals & Local Testing**
  - [ ] Moving to `forge`, `cast`, and `anvil`

---

## 📜 Testnet Transaction Log

Here are the real transactions broadcasted to Ethereum testnets during my hands-on exercises:

| # | Network | Type | Transaction Hash | Explorer Link | Nonce | Gas Used | Status |
|---|---------|------|------------------|---------------|-------|----------|--------|
| `01` | **Sepolia** | Faucet Drip (Funding) | `0x4a9b...[YOUR_TX_HASH]` | [View on Etherscan](https://sepolia.etherscan.io/) | `0` | `21,000` | ✅ Success |
| `02` | **Sepolia** | Native ETH Transfer | `0x7f2c...[YOUR_TX_HASH]` | [View on Etherscan](https://sepolia.etherscan.io/) | `1` | `21,000` | ✅ Success |
| `03` | **Tenderly Virtual Testnet** | State Trace & Gas Simulation | `0x1e8a...[YOUR_TX_HASH]` | [View on Tenderly](https://dashboard.tenderly.co/) | `2` | `21,000` | ✅ Success |

> 💡 *Replace the placeholder hashes and links with your actual transaction records from your testnet wallet.*

---

## 🏗️ Smart Contracts Overview

Located in [`/contracts`](contracts/):

```
                +---------------------+
                |  SimpleStorage.sol  | <---+ (Inherits & Overrides)
                | - store() [virtual] |     |
                | - retrieve() [view] |     |
                +---------------------+     |
                           ^                |
                           | Deploys & Calls|
                           |                |
                +---------------------+  +---------------------+
                | StorageFactory.sol  |  |  AddFiveStorage.sol |
                | - new SimpleStorage |  | - store() [override]|
                | - sfStore()         |  +---------------------+
                | - sfGet()           |
                +---------------------+
```

1. **[`SimpleStorage.sol`](contracts/SimpleStorage.sol)**: Fundamental storage slots, dynamic arrays, mappings, and events.
2. **[`StorageFactory.sol`](contracts/StorageFactory.sol)**: Deploys child contracts dynamically and orchestrates cross-contract calls.
3. **[`AddFiveStorage.sol`](contracts/AddFiveStorage.sol)**: Demonstrates OOP inheritance and method overriding (`super.store()`).

---

## 🛠️ CLI Developer Tool: `evm_inspector.py`

Located in [`scripts/evm_inspector.py`](scripts/evm_inspector.py), this Python utility calculates exact gas mechanics and simulates protocol fee burning.

```bash
# Calculate EIP-1559 transaction fees and burned portion
python scripts/evm_inspector.py --calc-fee --gas 21000 --base-fee 18.5 --priority-fee 1.5

# Simulate EIP-1559 base fee escalation over consecutive full blocks
python scripts/evm_inspector.py --eip1559-sim --start-fee 20.0 --blocks 5 --fullness 100
```

---

## 🧠 Core Web3 Concepts Mastered

### 1. Wallets & Key Cryptography
- **Private Key**: A 256-bit random number (`secp256k1` elliptic curve) used to sign transactions and prove ownership of funds without revealing the secret.
- **Public Key & Address**: Derived via elliptic curve multiplication from the private key, then hashed with Keccak-256 (the last 20 bytes form the Ethereum address).
- **Mnemonic Seed Phrases (BIP-39)**: A human-readable 12- or 24-word representation used by HD wallets to deterministically generate master keys and address paths (e.g. `m/44'/60'/0'/0/0`).

### 2. Testnets vs. Mainnet
- **Mainnet**: The production environment where ETH and assets carry real financial value.
- **Testnets (Sepolia, Holesky)**: Live staging networks running the exact same EVM consensus and execution rules, but using free test currency obtained from faucets.
- **Virtual Testnets (Tenderly, Anvil)**: Fast, zero-friction local or cloud forks ideal for rapid prototyping, debugging, and tracing without waiting for block times.

### 3. Proof of Stake & The EVM
- Ethereum operates as a distributed state machine (the **Ethereum Virtual Machine**).
- Validators stake 32 ETH to propose and attest to blocks every 12-second slot, governed by the Gasper consensus protocol.

---

## 🛡️ Security Best Practices Applied

- [x] **Isolated Developer Wallets**: Never use a wallet holding mainnet assets for development, testnet faucet claiming, or test dApp interactions.
- [x] **Zero Secret Leaks**: `.env` and sensitive configurations are strictly added to `.gitignore`. Private keys and seed phrases are never committed to version control.
- [x] **Signature Verification**: Checking chain IDs (`11155111` for Sepolia) and domain separators before signing raw payloads.

---

## 📂 Repository Structure

```text
web3-fundamentals-log/
├── README.md                           # Main project documentation & transaction log
├── .gitignore                          # Standard git ignore for secrets and temporary files
├── contracts/
│   ├── README.md                       # Architecture diagram, compilation & Remix guide
│   ├── SimpleStorage.sol               # State variables, structs, mappings, arrays
│   ├── StorageFactory.sol              # Factory Pattern & contract composability
│   └── AddFiveStorage.sol              # OOP Inheritance and function overriding
├── scripts/
│   └── evm_inspector.py                # Standalone CLI tool for EIP-1559 simulation & fee calculations
├── activities/
│   ├── 01-wallet-setup-and-security.md # Setup guide for burner wallet & seed phrase safety
│   ├── 02-testnet-faucets.md           # Claiming Sepolia testnet ETH & faucet mechanics
│   └── 03-first-testnet-tx.md          # Step-by-step transaction analysis & explorer review
└── notes/
    ├── blockchain-fundamentals.md      # Summary of consensus, hashing, and EVM architecture
    └── gas-and-mempool.md              # Deep dive into EIP-1559, nonces, and transaction states
```

---

## 🚀 What I'm Building Next

1. 🔨 **Foundry Toolkit**: Compiling, deploying, and fuzz testing with `forge`, `cast`, and `anvil`.
2. 📦 **FundMe Project**: Chainlink price feeds, custom errors, `immutable` / `constant` variables, and gas-efficient withdrawal patterns.

---

## 🤝 Connect & Acknowledgments

- **Learner**: [Your Name] ([LinkedIn Profile](https://linkedin.com/in/yourprofile) | [Twitter / X](https://x.com/yourhandle))
- **Learning Resource**: Huge thanks to [Patrick Collins](https://github.com/PatrickAlphaC) and the [Cyfrin Updraft](https://updraft.cyfrin.io/) community for creating accessible, industry-standard developer education.

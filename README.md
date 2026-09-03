# ⛓️ Web3 Fundamentals Log

> A comprehensive, hands-on engineering log of my deep dive into Ethereum, EVM architecture, Account Abstraction, Layer 2 scaling, and Smart Contract Development through the [Cyfrin Updraft](https://updraft.cyfrin.io/) curriculum.

[![Course](https://img.shields.io/badge/Course-Cyfrin%20Updraft%20Blockchain%20Basics-blue?style=flat-square)](https://updraft.cyfrin.io/)
[![Solidity](https://img.shields.io/badge/Solidity-%5E0.8.19-363636?style=flat-square&logo=solidity)](contracts/)
[![Network](https://img.shields.io/badge/Network-Ethereum%20Sepolia-627EEA?style=flat-square&logo=ethereum&logoColor=white)](#-testnet-transaction-log)
[![Account Abstraction](https://img.shields.io/badge/Standard-ERC--4337-orange?style=flat-square)](notes/wallets-and-account-abstraction.md)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)

---

## 🎯 About This Repository

Welcome! I am an aspiring Web3 & Smart Contract Engineer documenting my rigorous technical journey from core cryptographic principles to composable on-chain architectures.

Rather than passive video watching, this repository acts as my **verifiable proof of work**. It includes:
- **Comprehensive Technical Guides**: In-depth analysis of Wallets (EOA vs. Smart Account ERC-4337, MPC, Multisig), Layer 2 Rollups (Optimistic vs. ZK), EIP-4844 Blobs, and MEV dynamics.
- **Smart Contract Implementations**: Production-commented Solidity contracts demonstrating the Factory Pattern, OOP inheritance, function polymorphism, and gas-efficient storage.
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
- [ ] **Module 6: Next Step: Foundry Toolkit & FundMe Project**
  - [ ] Local testing with `forge`, RPC casting with `cast`, local chains with `anvil`
  - [ ] Chainlink Price Feeds & decentralized oracle integrations

---

## 📜 Testnet Transaction Log

Verifiable transactions broadcasted across Ethereum testnets during hands-on exercises:

| # | Network | Type | Transaction Hash | Explorer Link | Nonce | Gas Used | Status |
|---|---------|------|------------------|---------------|-------|----------|--------|
| `01` | **Sepolia** | Faucet Drip (Funding) | `0x4a9b...[YOUR_TX_HASH]` | [View on Etherscan](https://sepolia.etherscan.io/) | `0` | `21,000` | ✅ Success |
| `02` | **Sepolia** | Native ETH Transfer | `0x7f2c...[YOUR_TX_HASH]` | [View on Etherscan](https://sepolia.etherscan.io/) | `1` | `21,000` | ✅ Success |
| `03` | **Tenderly Virtual Testnet** | State Trace & Gas Simulation | `0x1e8a...[YOUR_TX_HASH]` | [View on Tenderly](https://dashboard.tenderly.co/) | `2` | `21,000` | ✅ Success |

---

## 🏗️ Smart Contracts Architecture

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

1. **[`SimpleStorage.sol`](contracts/SimpleStorage.sol)**: Core storage slots, dynamic arrays, mappings, events, and view functions.
2. **[`StorageFactory.sol`](contracts/StorageFactory.sol)**: Factory pattern orchestrating cross-contract deployments and method dispatching.
3. **[`AddFiveStorage.sol`](contracts/AddFiveStorage.sol)**: Object-Oriented inheritance (`is SimpleStorage`) and function overriding (`super.store()`).

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
- **[`notes/gas-and-mempool.md`](notes/gas-and-mempool.md)**: Math and dynamics of EIP-1559 fee markets and mempool sequencing.

---

## 📂 Repository Structure

```text
web3-fundamentals-log/
├── README.md                                     # Main project documentation & proof of work
├── .gitignore                                    # Strict secret and environment ignore rules
├── contracts/
│   ├── README.md                                 # Architecture diagram & Remix compilation guide
│   ├── SimpleStorage.sol                         # Base storage contract (structs, mappings, arrays)
│   ├── StorageFactory.sol                        # Factory Pattern & contract composability
│   └── AddFiveStorage.sol                        # OOP Inheritance & function overriding
├── scripts/
│   └── evm_inspector.py                          # CLI utility for EIP-1559, L2 fees, and speedups
├── activities/
│   ├── 01-wallet-setup-and-security.md           # Setup guide for burner wallet & seed safety
│   ├── 02-testnet-faucets.md                     # Claiming Sepolia ETH & faucet architecture
│   └── 03-first-testnet-tx.md                    # Transaction payload dissection & signature review
└── notes/
    ├── wallets-and-account-abstraction.md        # Cryptography, HD paths, MPC, and ERC-4337
    ├── networks-mainnet-testnets-l2s.md          # L1 vs L2 rollups, EIP-4844 blobs, and JSON-RPC
    ├── advanced-transaction-mechanics-and-mev.md # Mempool lifecycle, MEV attacks, and EIP-155
    ├── blockchain-fundamentals.md                # Consensus, Keccak-256, and EVM state
    └── gas-and-mempool.md                        # EIP-1559 fee markets and nonce sequencing
```

---

## 🤝 Connect & Acknowledgments

- **Learner**: [Your Name] ([GitHub](https://github.com/totaliyahtrash) | [LinkedIn Profile](https://linkedin.com/in/yourprofile))
- **Learning Resource**: Huge thanks to [Patrick Collins](https://github.com/PatrickAlphaC) and the [Cyfrin Updraft](https://updraft.cyfrin.io/) community for creating industry-standard Web3 developer education.

# ⛓️ Web3 Fundamentals Log

> A documented, hands-on learning log of my first steps into Ethereum, Web3 development, and the EVM ecosystem through the [Cyfrin Updraft](https://updraft.cyfrin.io/) *Blockchain Basics* curriculum.

[![Course](https://img.shields.io/badge/Course-Cyfrin%20Updraft%20Blockchain%20Basics-blue?style=flat-square)](https://updraft.cyfrin.io/)
[![Status](https://img.shields.io/badge/Status-Completed-success?style=flat-square)](#-course-progress-checklist)
[![Network](https://img.shields.io/badge/Network-Ethereum%20Sepolia-627EEA?style=flat-square&logo=ethereum&logoColor=white)](#-testnet-transaction-log)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)

---

## 🎯 About This Repository

Welcome! I am an aspiring Web3 / Smart Contract Developer documenting my fundamentals from day one. 

Rather than treating learning as passive video-watching, this repository serves as my **verifiable proof of work**. It contains:
- Detailed breakdown of my first transactions executed on Ethereum testnets.
- Technical explanations of fundamental concepts (gas mechanics, transaction lifecycles, cryptographic key pairs).
- Security practices implemented from day one (developer wallet isolation, seed phrase management).
- Clear, structured notes that demonstrate my comprehension of how the EVM and decentralized ledgers work under the hood.

---

## 🧭 Course Progress Checklist

Tracked progress through the **Cyfrin Updraft Blockchain Basics** course taught by Patrick Collins:

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
- [ ] **Module 5: Next Step: Solidity Smart Contract Development**
  - [ ] Moving to *Solidity 101* & *Foundry Fundamentals*

---

## 📜 Testnet Transaction Log

Here are the real transactions broadcasted to Ethereum testnets during my hands-on exercises.

| # | Network | Type | Transaction Hash | Explorer Link | Nonce | Gas Used (Gwei) | Status |
|---|---------|------|------------------|---------------|-------|-----------------|--------|
| `01` | **Sepolia** | Faucet Drip (Funding) | `0x4a9b...[YOUR_TX_HASH_HERE]` | [View on Etherscan](https://sepolia.etherscan.io/) | `0` | `21,000` | ✅ Success |
| `02` | **Sepolia** | Native ETH Transfer | `0x7f2c...[YOUR_TX_HASH_HERE]` | [View on Etherscan](https://sepolia.etherscan.io/) | `1` | `21,000` | ✅ Success |
| `03` | **Tenderly Virtual Testnet** | State Trace & Gas Simulation | `0x1e8a...[YOUR_TX_HASH_HERE]` | [View on Tenderly Explorer](https://dashboard.tenderly.co/) | `2` | `21,000` | ✅ Success |

> 💡 *Replace the placeholder hashes and links with your actual transaction records from your testnet wallet.*

---

## 🔍 Deep-Dive: Anatomy of My First Transaction

When sending standard testnet ETH from `Account A` to `Account B`, I inspected the raw transaction payload and observed the following parameters:

```json
{
  "from": "0xYourSenderAddress...",
  "to": "0xYourRecipientAddress...",
  "value": "100000000000000000", // 0.1 Sepolia ETH (in Wei)
  "nonce": 1,
  "gasLimit": "21000",
  "maxFeePerGas": "1500000000", // 1.5 Gwei
  "maxPriorityFeePerGas": "1000000000", // 1.0 Gwei (Tip)
  "chainId": 11155111, // Sepolia Testnet ID
  "data": "0x" // Empty for simple transfers
}
```

### Key Learnings from this Transaction:
1. **Gas Limit vs Gas Used**: A standard native ETH transfer strictly consumes `21,000` units of gas. Any unused gas from the gas limit is refunded.
2. **The Role of the Nonce**: The `nonce` is a strictly sequential counter tracking how many transactions have originated from this address. If transaction `nonce 1` is stuck in the mempool, `nonce 2` cannot be processed before it.
3. **EIP-1559 Dynamics**:
   $$\text{Total Gas Fee} = \text{Gas Used} \times (\text{Base Fee} + \text{Priority Fee})$$
   The `Base Fee` is burned by the protocol, while the `Priority Fee` (tip) goes to the validator who proposes the block.

---

## 🧠 Core Web3 Concepts Mastered

### 1. Wallets & Key Cryptography
- **Private Key**: A 256-bit random number (e.g. `secp256k1` elliptic curve) used to sign transactions and prove ownership of funds without revealing the secret.
- **Public Key & Address**: Derived via elliptic curve multiplication from the private key, then hashed with Keccak-256 (the last 20 bytes form the Ethereum address).
- **Mnemonic Seed Phrases (BIP-39)**: A human-readable 12- or 24-word representation used by HD wallets to deterministically generate master keys and address paths (e.g. `m/44'/60'/0'/0/0`).

### 2. Testnets vs. Mainnet
- **Mainnet**: The production environment where ETH and assets carry real financial value.
- **Testnets (Sepolia, Holesky)**: Live staging networks running the exact same EVM consensus and execution rules, but using free test currency obtained from faucets.
- **Virtual Testnets (Tenderly, Anvil, Hardhat Network)**: Fast, zero-friction local or cloud forks ideal for rapid prototyping, debugging, and tracing without waiting for block times.

### 3. Proof of Stake & The EVM
- Ethereum operates as a distributed state machine (the **Ethereum Virtual Machine**).
- Validators stake 32 ETH to propose and attest to blocks every 12-second slot, governed by the Gasper consensus protocol (combining Casper FFG and LMD-GHOST).

---

## 🛡️ Security Best Practices Applied

- [x] **Isolated Developer Wallets**: Never use a wallet holding mainnet assets for development, testnet faucet claiming, or test dApp interactions.
- [x] **Zero Secret Leaks**: `.env` and sensitive configurations are strictly added to `.gitignore`. Private keys and seed phrases are never committed to version control.
- [x] **Signature Verification**: Checking chain IDs (`11155111` for Sepolia) and domain separators before signing raw payloads.

---

## 📂 Repository Structure

```text
my-first-blockchain-transactions/
├── README.md                           # Main project documentation & transaction log
├── .gitignore                          # Standard git ignore for secrets and temporary files
├── activities/
│   ├── 01-wallet-setup-and-security.md # Setup guide for burner wallet & seed phrase safety
│   ├── 02-testnet-faucets.md           # Claiming Sepolia testnet ETH & faucet mechanics
│   └── 03-first-testnet-tx.md          # Step-by-step transaction analysis & explorer review
├── notes/
│   ├── blockchain-fundamentals.md      # Summary of consensus, hashing, and EVM architecture
│   └── gas-and-mempool.md              # Deep dive into EIP-1559, nonces, and transaction states
└── screenshots/
    └── .gitkeep                        # Folder to store Etherscan & wallet confirmation screenshots
```

---

## 🚀 What I'm Building Next

Having established a rock-solid foundation in blockchain mechanics, transaction lifecycles, and wallet security, my immediate roadmap includes:

1. 💻 **Solidity 101**: Writing my first `SimpleStorage.sol` smart contract.
2. 🔨 **Foundry Toolkit**: Local contract compilation, deployment scripting, and fuzz testing with `forge`, `cast`, and `anvil`.
3. 📦 **Full Stack Web3 / DeFi**: Writing unit tests, understanding reentrancy, and interacting with live testnet smart contracts.

---

## 🤝 Connect & Acknowledgments

- **Learner**: [Your Name] ([@YourTwitterOrLinkedIn](https://linkedin.com/in/yourprofile))
- **Learning Resource**: Huge thanks to [Patrick Collins](https://github.com/PatrickAlphaC) and the [Cyfrin Updraft](https://updraft.cyfrin.io/) community for creating accessible, industry-standard developer education.

---
*Licensed under the [MIT License](LICENSE).*

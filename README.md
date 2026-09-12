# ⛓️ Web3 Fundamentals Log

> A comprehensive, production-grade engineering log of my journey into Ethereum, EVM internals, Account Abstraction (ERC-4337), Multi-Signature Treasury Wallets, Cryptographic Merkle Airdrops, Smart Contract Security & Invariant Fuzzing, Upgradeable Proxies (ERC-1967), AMM DEX Protocols (CPAMM), DeFi Stablecoins (DSC Engine), Dynamic On-Chain NFTs (ERC-721), and Provably Fair Lotteries (Chainlink VRF & Automation).

[![CI](https://github.com/totaliyahtrash/web3-fundamentals-log/actions/workflows/test.yml/badge.svg)](https://github.com/totaliyahtrash/web3-fundamentals-log/actions)
[![Course](https://img.shields.io/badge/Course-Cyfrin%20Updraft-blue?style=flat-square)](https://updraft.cyfrin.io/)
[![Solidity](https://img.shields.io/badge/Solidity-%5E0.8.19-363636?style=flat-square&logo=solidity)](contracts/)
[![Foundry](https://img.shields.io/badge/Framework-Foundry-red?style=flat-square&logo=ethereum)](test/)
[![Multi-Sig](https://img.shields.io/badge/Governance-M--of--N%20MultiSig-darkblue?style=flat-square)](contracts/multisig/MultiSigWallet.sol)
[![Security & Invariants](https://img.shields.io/badge/Security-Invariant%20Fuzzing-critical?style=flat-square)](notes/smart-contract-security-and-auditing.md)
[![Merkle Airdrop](https://img.shields.io/badge/Cryptography-Merkle%20Tree%20Airdrop-teal?style=flat-square)](contracts/airdrops/MerkleAirdrop.sol)
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

Welcome! I am an aspiring Web3 & Smart Contract Engineer documenting my rigorous technical journey from core cryptographic principles to audited, invariant-tested DeFi protocols and governance systems.

Rather than passive video watching, this repository acts as my **verifiable proof of work**. It includes:
- **Production Smart Contracts**:
  - `multisig/`: $M$-of-$N$ threshold multi-signature treasury wallet (`MultiSigWallet.sol`) enabling arbitrary calldata execution upon consensus.
  - `airdrops/`: Cryptographic Merkle Tree token distribution verifying $O(\log N)$ membership proofs with $O(1)$ on-chain storage.
  - `defi/`: Algorithmic overcollateralized stablecoin engine (`DSCEngine.sol`) with liquidations, and Constant Product AMM DEX (`CPAMM.sol`).
  - `upgrades/`: Upgradeable proxy patterns (`ERC1967Proxy.sol`, `BoxV1.sol`, `BoxV2.sol`) with assembly `delegatecall` and state preservation.
  - `nfts/`: Fully on-chain dynamic SVG NFTs (`MoodNft.sol`, `BasicNft.sol`) encoding graphics into Base64.
  - `raffle/`: Provably fair lottery (`Raffle.sol`) with **Chainlink VRF v2.5** and **Chainlink Automation**.
  - `fundme/`: Crowdfunding (`FundMe.sol`) with **Chainlink Price Feeds**, custom errors, and memory caching (`cheaperWithdraw`).
  - `tokens/`: Full **EIP-20** token standard implementation from scratch (`ManualToken.sol`).
  - `storage/`: Factory deployment and OOP inheritance (`StorageFactory.sol`, `AddFiveStorage.sol`).
- **Foundry Invariant Fuzzing & Testing**: Handler-based stateful fuzzing (`test/fuzz/Handler.sol`, `test/fuzz/Invariants.t.sol`) and unit suites validating protocol properties.
- **CI/CD Automation & Developer Workflows**: Fully configured GitHub Actions pipeline (`.github/workflows/test.yml`) running test suites and bytecode size assertions on every commit.

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
- [x] **Module 13: Cryptographic Merkle Tree Airdrops (`MerkleAirdrop.sol`)**
  - [x] Commutative pair hashing & double-hashed leaf construction against second-preimage attacks
  - [x] $O(1)$ on-chain storage with $O(\log N)$ proof verification
- [x] **Module 14: Multi-Signature Treasury Governance (`MultiSigWallet.sol`)**
  - [x] $M$-of-$N$ threshold proposal, confirmation, and execution workflow
  - [x] Low-level arbitrary calldata execution for DAO treasury and protocol management
- [x] **Module 15: Smart Contract Security, Auditing & Invariant Fuzzing**
  - [x] Threat models: Reentrancy (CEI pattern), Oracle Manipulation, Flash Loans, and Precision Loss
  - [x] Stateful Property-Based Invariant Fuzzing with Foundry (`test/fuzz/Invariants.t.sol`)

---

## 🧪 Foundry Automated Testing & Invariant Fuzzing

```bash
# Run all unit and invariant tests across all suites
forge test

# Run tests for MultiSig Treasury Wallet
forge test --match-contract MultiSigTest -vvv

# Run tests for Merkle Airdrop verification
forge test --match-contract MerkleAirdropTest -vvv

# Run stateful invariant fuzz testing with detailed trace
forge test --match-contract InvariantsTest -vvvv

# Run tests for Upgradeable Proxies
forge test --match-contract UpgradeTest -vvv

# Run tests for Constant Product AMM DEX
forge test --match-contract CPAMMTest -vvv

# Run gas snapshot analysis
forge snapshot
```

---

## 📂 Repository Structure

```text
web3-fundamentals-log/
├── README.md                                     # Master documentation, architecture & roadmap
├── LICENSE                                       # Open-source MIT License
├── Makefile                                      # Web3 developer workflow automation shortcuts
├── SECURITY.md                                   # Security policy & vulnerability reporting
├── foundry.toml                                  # Foundry framework & invariant configuration
├── .gitignore                                    # Strict secret and environment ignore rules
├── .github/
│   └── workflows/
│       └── test.yml                              # Continuous Integration (CI) test pipeline
├── contracts/
│   ├── README.md                                 # Full architecture & deployment guide
│   ├── multisig/
│   │   └── MultiSigWallet.sol                    # M-of-N threshold treasury wallet
│   ├── airdrops/
│   │   ├── MerkleProof.sol                       # Cryptographic Merkle proof verifier
│   │   └── MerkleAirdrop.sol                     # O(1) gas-efficient token airdrop distributor
│   ├── defi/
│   │   ├── CPAMM.sol                             # Constant Product Automated Market Maker DEX
│   │   ├── DSCEngine.sol                         # Core DeFi collateral & liquidation engine
│   │   └── DecentralizedStableCoin.sol           # Algorithmic pegged ERC-20 stablecoin
│   ├── fundme/
│   │   ├── FundMe.sol                            # Crowdfunding with Chainlink & gas patterns
│   │   └── PriceConverter.sol                    # Library for Chainlink AggregatorV3Interface
│   ├── nfts/
│   │   ├── Base64.sol                            # Assembly-level Base64 string encoder
│   │   ├── BasicNft.sol                          # ERC-721 token standard from scratch
│   │   └── MoodNft.sol                           # Dynamic on-chain SVG NFT with state flipping
│   ├── raffle/
│   │   └── Raffle.sol                            # Provably fair lottery with VRF & Automation
│   ├── storage/
│   │   ├── SimpleStorage.sol                     # Base storage contract (structs, mappings, arrays)
│   │   ├── StorageFactory.sol                    # Factory Pattern & contract composability
│   │   └── AddFiveStorage.sol                    # OOP Inheritance & function overriding
│   ├── tokens/
│   │   └── ManualToken.sol                       # ERC-20 Token Standard from scratch
│   ├── upgrades/
│   │   ├── ERC1967Proxy.sol                      # Collision-resistant delegatecall proxy
│   │   ├── BoxV1.sol                             # Initial logic implementation (v1.0.0)
│   │   └── BoxV2.sol                             # Upgraded implementation (v2.0.0 + increment)
│   └── mocks/
│       ├── MockVRFCoordinator.sol                # Mock Chainlink VRF for local testing
│       └── MockV3Aggregator.sol                  # Mock Chainlink Price Feed for local testing
├── test/
│   ├── fuzz/
│   │   ├── Handler.sol                           # Action bounding handler for stateful fuzzing
│   │   └── Invariants.t.sol                      # Core protocol mathematical invariant test suite
│   ├── MultiSigTest.t.sol                        # Automated unit tests for MultiSig Wallet
│   ├── MerkleAirdropTest.t.sol                   # Automated unit tests for Merkle Tree Airdrops
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
    ├── smart-contract-security-and-auditing.md   # Reentrancy, oracle attacks, CEI, and invariant fuzzing
    ├── wallets-and-account-abstraction.md        # Cryptography, HD paths, MPC, and ERC-4337
    ├── networks-mainnet-testnets-l2s.md          # L1 vs L2 rollups, EIP-4844 blobs, and JSON-RPC
    ├── advanced-transaction-mechanics-and-mev.md # Mempool lifecycle, MEV attacks, and EIP-155
    └── blockchain-fundamentals.md                # Consensus, Keccak-256, and EVM state
```

---

## 🤝 Connect & Acknowledgments

- **Learner**: [totaliyahtrash](https://github.com/totaliyahtrash)
- **Learning Resource**: Built while mastering the [Cyfrin Updraft](https://updraft.cyfrin.io/) curriculum by [Patrick Collins](https://github.com/PatrickAlphaC).

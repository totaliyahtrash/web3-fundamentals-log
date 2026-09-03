# 🌐 Guide: Networks, Testnets, Layer 2 Rollups & JSON-RPC Architecture

*Advanced Web3 Study Notes | Cyfrin Updraft Learning Path*

---

## 1. The Ethereum Network Hierarchy

```
+-----------------------------------------------------------------------------+
|                               Ethereum Ecosystem                            |
|                                                                             |
|  [ Layer 1: Settlement & Consensus Layer ]                                  |
|   ├── Ethereum Mainnet (Chain ID: 1) ──► Real financial value & finality    |
|   ├── Sepolia Testnet (Chain ID: 11155111) ──► App & smart contract testing |
|   └── Holesky Testnet (Chain ID: 17000) ──► Staking & validator testing     |
|                                                                             |
|  [ Layer 2: Execution & Scaling Layer (Rollups) ]                           |
|   ├── Optimistic Rollups ──► Arbitrum One (42161), OP Mainnet (10)          |
|   └── Zero-Knowledge (ZK) Rollups ──► zkSync Era (324), Scroll (534352)     |
|                                                                             |
|  [ Local & Virtual Development Environments ]                               |
|   ├── Anvil (Foundry) / Hardhat Network ──► Instant local EVM state         |
|   └── Tenderly Virtual Testnets ──► Zero-cost cloud forks with state tracing|
+-----------------------------------------------------------------------------+
```

---

## 2. Testnets Comparison

| Network | Chain ID | Consensus / State | Primary Purpose | Faucet Source |
|---|---|---|---|---|
| **Sepolia** | `11155111` | Proof-of-Stake (Permissioned Validators) | Smart contract testing, dApp deployment, gas optimization | Google Cloud, Alchemy, Infura Faucets |
| **Holesky** | `17000` | Proof-of-Stake (Open Validator Set) | Infrastructure, protocol upgrades, validator node operations | Holesky PoW Faucet |
| **Local Anvil / Hardhat** | `31337` | Single-node instant execution | Unit tests, continuous integration, gas profiling | Built-in 10,000 prefunded accounts |

---

## 3. Layer 2 Rollups: Optimistic vs. Zero-Knowledge

Layer 2 rollups scale Ethereum by executing transactions off-chain and posting compressed transaction batches to Layer 1 for data availability and final settlement.

```
                           +------------------------+
                           |  Layer 2 Execution     |
                           |  (1,000s of Tx/sec)    |
                           +------------------------+
                                       │
            ┌──────────────────────────┴──────────────────────────┐
            ▼                                                     ▼
+-----------------------+                             +-----------------------+
|  Optimistic Rollups   |                             |   ZK-Rollups (STARKs) |
| (Arbitrum / Optimism) |                             |  (zkSync / Scroll)    |
+-----------------------+                             +-----------------------+
| Assumes txs are valid |                             | Uses cryptographic    |
| by default.           |                             | validity proofs       |
| 7-day challenge window|                             | (ZK-SNARK / ZK-STARK).|
| for fraud proofs      |                             | Instant cryptographic |
| before L1 finality.   |                             | finality on L1.       |
+-----------------------+                             +-----------------------+
            │                                                     │
            └──────────────────────────┬──────────────────────────┘
                                       ▼
                     +-----------------------------------+
                     |  Layer 1 Ethereum (EIP-4844 Blobs)|
                     |  Data Availability & Settlement   |
                     +-----------------------------------+
```

### EIP-4844 (Proto-Danksharding & Blobs)
- Introduced temporary **Blob storage** on Layer 1 blocks (available for $\approx 18\text{ days}$).
- Dramatically reduced L2 batch submission fees (slashing L2 transaction costs by up to $90\%$) by separating transient rollup data from permanent EVM execution state storage.

---

## 4. How Nodes & RPC Providers Work (JSON-RPC)

When a dApp or wallet interacts with Ethereum, it communicates over HTTP or WebSockets with an RPC node using standard **JSON-RPC 2.0 specification**.

```
[ Frontend / dApp ] ──(ethers.js / viem)──► [ RPC Provider: Infura/Alchemy ] ──► [ Execution Client: Geth/Reth ]
```

### Core JSON-RPC Methods Mastered:

1. **`eth_call`**:
   - Executes a read-only smart contract call locally on the node's EVM instance without publishing a transaction to the network.
   - **Gas Cost: 0** (No state mutation, no signature required).
2. **`eth_sendRawTransaction`**:
   - Broadcasts a cryptographically signed transaction payload (`0x02f8...`) to the node's mempool for gossip propagation across the P2P network.
3. **`eth_estimateGas`**:
   - Simulates transaction execution against the current pending state to predict how many gas units the execution will consume.
4. **`eth_getTransactionReceipt`**:
   - Queries the execution receipt of a mined transaction, returning the block number, status (`0x1` = success, `0x0` = revert), gas used, and emitted event logs.
5. **`eth_getBalance`**:
   - Returns the native balance of an account at a specific block number or state tag (`latest`, `pending`, `finalized`).

---

## 5. Cross-Chain Bridging & Security Fundamentals

- **Canonical Bridges**: Smart contracts deployed on both L1 and L2 where native assets are locked in an L1 escrow contract and minted as representation tokens on L2.
- **Lock-and-Mint vs. Burn-and-Mint**:
  - *Lock & Mint*: Lock Token $A$ on Source Chain $\rightarrow$ Mint Wrapped Token $A$ on Destination Chain.
  - *Burn & Mint*: Burn Wrapped Token $A$ on Source Chain $\rightarrow$ Release/Mint Original Token $A$ on Destination Chain.
- **Bridge Security Risks**: Cross-chain messaging relays and validator multi-sigs represent the highest-value honeypots in Web3, necessitating formal verification and proof-based relays.

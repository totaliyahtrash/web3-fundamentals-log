# 📜 Smart Contracts: Core Architecture

This directory contains my Solidity smart contracts developed as part of the [Cyfrin Updraft](https://updraft.cyfrin.io/) curriculum.

---

## 🏗️ Contracts Architecture & Patterns

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

---

## 📄 File Summaries

### 1. [`SimpleStorage.sol`](./SimpleStorage.sol)
- **EVM Primitives**: State storage variables, custom `struct Person`, dynamic arrays, and $O(1)$ key-value mappings.
- **Gas Optimization**: Uses `calldata` for non-mutated external string arguments.
- **Events**: Emits indexed EVM logs (`NumberUpdated`, `PersonAdded`) for transaction receipts and dApp subgraphs.

### 2. [`StorageFactory.sol`](./StorageFactory.sol)
- **Factory Pattern**: Demonstrates on-chain contract deployment using `new SimpleStorage()`.
- **Contract Composability**: Interacting with external contracts by casting stored addresses to their contract types (`SimpleStorage(targetAddress).store(...)`).

### 3. [`AddFiveStorage.sol`](./AddFiveStorage.sol)
- **Object-Oriented Solidity**: Demonstrates inheritance (`is SimpleStorage`), polymorphism, and function overriding with `virtual` and `override` specifiers.

---

## 🛠️ Testing & Deployment Guide (Remix IDE)

1. Open [Remix IDE](https://remix.ethereum.org/).
2. Create workspace files for `SimpleStorage.sol`, `StorageFactory.sol`, and `AddFiveStorage.sol`.
3. Under **Solidity Compiler**, select `0.8.19` (or newer) and compile.
4. Deploy `StorageFactory.sol`:
   - Call `createSimpleStorageContract()` $\rightarrow$ deploys a new child contract.
   - Call `sfStore(0, 77)` $\rightarrow$ delegates call to the deployed child.
   - Call `sfGet(0)` $\rightarrow$ verifies storage returns `77`.

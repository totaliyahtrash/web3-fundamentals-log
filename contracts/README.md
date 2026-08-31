# 📜 Smart Contracts: First Steps

This directory contains my first Solidity smart contract(s) developed following the [Cyfrin Updraft](https://updraft.cyfrin.io/) curriculum.

---

## 📄 Contracts Overview

### 1. [`SimpleStorage.sol`](./SimpleStorage.sol)
My first complete smart contract demonstrating core Solidity primitives and EVM storage mechanics.

#### Key Solidity Concepts Implemented:
- **Pragma & License Identifiers**: Specifying compiler compatibility (`^0.8.19`) and open-source licensing (`MIT`).
- **Data Types**: `uint256`, `string`, `address`, and custom `struct` definitions.
- **Data Location (`calldata` vs `memory` vs `storage`)**: Using `calldata` for non-modified external function parameters to minimize gas consumption.
- **Data Structures**:
  - `Person[]` (Dynamic array for sequential storage)
  - `mapping(string => uint256)` (Hash table for $O(1)$ key lookup)
- **Functions & Visibility**:
  - `store()`: Modifies state $\rightarrow$ creates a transaction $\rightarrow$ consumes gas.
  - `retrieve()`: Marked `view` $\rightarrow$ reads state $\rightarrow$ zero gas when called off-chain.
- **Events & Indexing**: Emitting `NumberUpdated` and `PersonAdded` to log state changes into EVM transaction logs / receipts.

---

## 🛠️ How to Compile & Test in Remix IDE

1. Open [Remix Ethereum IDE](https://remix.ethereum.org/).
2. Create a file named `SimpleStorage.sol` and paste the code.
3. Under the **Solidity Compiler** tab, select compiler version `0.8.19` and click **Compile SimpleStorage.sol**.
4. Navigate to the **Deploy & Run Transactions** tab:
   - Environment: `Remix VM (Cancun)` or `Injected Provider - MetaMask` (for Sepolia Testnet).
   - Click **Deploy**.
5. Interact with the deployed contract buttons:
   - Call `store(42)` $\rightarrow$ signs and broadcasts transaction.
   - Call `retrieve()` $\rightarrow$ immediately returns `42`.
   - Call `addPerson("Alice", 7)` $\rightarrow$ updates mapping and array.

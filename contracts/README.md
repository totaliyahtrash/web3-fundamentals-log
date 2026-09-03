# 📜 Smart Contracts: Architecture & Production Patterns

This directory contains production-grade Solidity smart contracts developed throughout the [Cyfrin Updraft](https://updraft.cyfrin.io/) curriculum.

---

## 🏗️ Contracts Architecture & Patterns

```
+---------------------------------------------------------------------------------+
|                               Smart Contract Suite                              |
|                                                                                 |
|  [ Foundational Storage Suite ]                                                 |
|    SimpleStorage.sol  <─── (Inherits) ───  AddFiveStorage.sol                   |
|           ▲                                                                     |
|           └────────── (Deploys & Calls) ─── StorageFactory.sol                  |
|                                                                                 |
|  [ Token Standards Suite ]                                                      |
|    tokens/ManualToken.sol (EIP-20 Standard from scratch with custom errors)    |
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

---

## 📄 File Summaries

### 1. [`tokens/ManualToken.sol`](./tokens/ManualToken.sol)
- **EIP-20 Token Standard From Scratch**: Complete implementation of ERC-20 mechanics (`transfer`, `approve`, `transferFrom`, `allowance`, `balanceOf`).
- **Custom Errors**: `Token__InsufficientBalance`, `Token__AllowanceExceeded`, and `Token__ZeroAddressNotAllowed`.
- **Event Logging**: Full `Transfer` and `Approval` event emission for indexer compatibility.

### 2. [`FundMe.sol`](./FundMe.sol)
- **Decentralized Crowdfunding**: Accepts native ETH contributions with a minimum constraint enforced in USD ($5 USD).
- **Oracle Integration**: Queries Chainlink Price Feeds dynamically via the `PriceConverter` library.
- **Gas Optimization Patterns**:
  - `constant` for `MINIMUM_USD` (compiled directly into bytecode, 0 storage reads).
  - `immutable` for `i_owner` and `i_priceFeed` (written once in constructor, stored in bytecode).
  - **Custom Errors** (`revert FundMe__NotOwner()`) saving hundreds of gas compared to legacy `require(..., "string")`.
  - **`cheaperWithdraw()` pattern**: Caches the storage `s_funders` array into local `memory` to eliminate repeated expensive `SLOAD` opcodes ($\approx 2,100\text{ gas}$ each).

### 3. [`PriceConverter.sol`](./PriceConverter.sol)
- Reusable Solidity `library` handling Chainlink Aggregator decimals adjustment ($8\text{ decimals} \rightarrow 18\text{ decimals}$) and Wei-to-USD conversion.

### 4. [`mocks/MockV3Aggregator.sol`](./mocks/MockV3Aggregator.sol)
- Standalone mock oracle used for local testing in Remix and Anvil without needing live testnet connections.

### 5. [`SimpleStorage.sol`](./SimpleStorage.sol), [`StorageFactory.sol`](./StorageFactory.sol), [`AddFiveStorage.sol`](./AddFiveStorage.sol)
- State storage variables, dynamic arrays, mappings, factory pattern (`new`), and OOP inheritance (`virtual` / `override`).

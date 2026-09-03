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

### 1. [`FundMe.sol`](./FundMe.sol)
- **Decentralized Crowdfunding**: Accepts native ETH contributions with a minimum constraint enforced in USD ($5 USD).
- **Oracle Integration**: Queries Chainlink Price Feeds dynamically via the `PriceConverter` library.
- **Gas Optimization Patterns**:
  - `constant` for `MINIMUM_USD` (compiled directly into bytecode, 0 storage reads).
  - `immutable` for `i_owner` and `i_priceFeed` (written once in constructor, stored in bytecode).
  - **Custom Errors** (`revert FundMe__NotOwner()`) saving hundreds of gas compared to legacy `require(..., "string")`.
  - **`cheaperWithdraw()` pattern**: Caches the storage `s_funders` array into local `memory` to eliminate repeated expensive `SLOAD` opcodes ($\approx 2,100\text{ gas}$ each).
- **Native ETH Routing**: Implements `receive()` and `fallback()` to ensure users sending raw ETH directly to the contract address still have their contributions credited.

### 2. [`PriceConverter.sol`](./PriceConverter.sol)
- Reusable Solidity `library` handling Chainlink Aggregator decimals adjustment ($8\text{ decimals} \rightarrow 18\text{ decimals}$) and Wei-to-USD conversion.

### 3. [`mocks/MockV3Aggregator.sol`](./mocks/MockV3Aggregator.sol)
- Standalone mock oracle used for local testing in Remix and Anvil without needing live testnet connections.

### 4. [`SimpleStorage.sol`](./SimpleStorage.sol), [`StorageFactory.sol`](./StorageFactory.sol), [`AddFiveStorage.sol`](./AddFiveStorage.sol)
- State storage variables, dynamic arrays, mappings, factory pattern (`new`), and OOP inheritance (`virtual` / `override`).

---

## 🛠️ Testing & Deploying `FundMe.sol` in Remix IDE

1. Open [Remix IDE](https://remix.ethereum.org/).
2. Paste `PriceConverter.sol`, `FundMe.sol`, and `mocks/MockV3Aggregator.sol`.
3. Under **Solidity Compiler**, select `0.8.19` and compile.
4. **Deploy Mock Oracle First**:
   - Deploy `MockV3Aggregator.sol` with `_decimals = 8` and `_initialAnswer = 300000000000` ($3,000 / ETH).
   - Copy the deployed mock address.
5. **Deploy `FundMe.sol`**:
   - Pass the mock oracle address as the constructor argument `priceFeedAddress`.
   - On Sepolia Testnet, use the official Chainlink ETH/USD address: `0x694AA1769357215DE4FAC081bf1f309aDC325306`.
6. **Interact**:
   - In the **Value** field, enter `0.01 Ether` and click `fund()`.
   - Call `retrieve()`, `getFundersCount()`, and test `cheaperWithdraw()`.

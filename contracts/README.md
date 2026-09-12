# 📜 Smart Contracts: Architecture & Production Patterns

This directory contains production-grade Solidity smart contracts developed throughout the [Cyfrin Updraft](https://updraft.cyfrin.io/) curriculum.

---

## 🏗️ Contracts Architecture & Patterns

```
+---------------------------------------------------------------------------------+
|                               Smart Contract Suite                              |
|                                                                                 |
|  [ Provably Fair Lottery Suite ]                                                |
|    Chainlink VRF Coordinator (Verifiable Random Function v2.5)                   |
|           ▲                                                                     |
|           │ (Delivers Cryptographic Randomness)                                 |
|    Chainlink Automation (Decentralized Time & State Trigger)                    |
|           ▲                                                                     |
|           │ (Triggers checkUpkeep -> performUpkeep)                             |
|    raffle/Raffle.sol (Autonomous Provably Fair Lottery with Enum State Machine) |
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
|                                                                                 |
|  [ Token Standards Suite ]                                                      |
|    tokens/ManualToken.sol (EIP-20 Standard from scratch with custom errors)     |
|                                                                                 |
|  [ Foundational Storage Suite ]                                                 |
|    SimpleStorage.sol  <─── (Inherits) ───  AddFiveStorage.sol                   |
|           ▲                                                                     |
|           └────────── (Deploys & Calls) ─── StorageFactory.sol                  |
+---------------------------------------------------------------------------------+
```

---

## 📄 File Summaries

### 1. [`raffle/Raffle.sol`](./raffle/Raffle.sol)
- **Provably Fair Lottery**: Guarantees unbiasable winner selection using **Chainlink VRF v2.5**.
- **Decentralized Autonomous Automation**: Integrates **Chainlink Automation** (`checkUpkeep` & `performUpkeep`) to trigger draws automatically when time and player thresholds are satisfied.
- **State Machine Protection**: Implements `enum RaffleState { OPEN, CALCULATING }` to prevent frontrunning and block new ticket entries while the random word is being generated.
- **Custom Errors**: `Raffle__SendMoreToEnterRaffle`, `Raffle__RaffleNotOpen`, `Raffle__UpkeepNotNeeded`, `Raffle__TransferFailed`.

### 2. [`FundMe.sol`](./FundMe.sol)
- **Decentralized Crowdfunding**: Accepts native ETH contributions with a minimum constraint enforced in USD ($5 USD).
- **Oracle Integration**: Queries Chainlink Price Feeds dynamically via the `PriceConverter` library.
- **Gas Optimization Patterns**:
  - `constant` for `MINIMUM_USD` (compiled directly into bytecode, 0 storage reads).
  - `immutable` for `i_owner` and `i_priceFeed` (written once in constructor, stored in bytecode).
  - **Custom Errors** (`revert FundMe__NotOwner()`) saving hundreds of gas compared to legacy `require(..., "string")`.
  - **`cheaperWithdraw()` pattern**: Caches the storage `s_funders` array into local `memory` to eliminate repeated expensive `SLOAD` opcodes ($\approx 2,100\text{ gas}$ each).

### 3. [`tokens/ManualToken.sol`](./tokens/ManualToken.sol)
- **EIP-20 Token Standard From Scratch**: Complete implementation of ERC-20 mechanics (`transfer`, `approve`, `transferFrom`, `allowance`, `balanceOf`).
- **Custom Errors**: `Token__InsufficientBalance`, `Token__AllowanceExceeded`, and `Token__ZeroAddressNotAllowed`.

### 4. [`mocks/MockVRFCoordinator.sol`](./mocks/MockVRFCoordinator.sol) & [`mocks/MockV3Aggregator.sol`](./mocks/MockV3Aggregator.sol)
- Mock oracles for local Foundry test execution without requiring network connectivity.

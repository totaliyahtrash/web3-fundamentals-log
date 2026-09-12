# 🛡️ Comprehensive Guide: Smart Contract Security, Common Vulnerabilities & Invariant Fuzzing

*Advanced Web3 Security & Auditing | Cyfrin Updraft Learning Path*

---

## 1. The Threat Model & Audit Methodology

Smart contracts handle irreversible financial transactions in an adversarial environment where any vulnerability will be exploited by autonomous bots or black-hat attackers.

```
+-----------------------------------------------------------------------------+
|                        Security & Verification Hierarchy                    |
|                                                                             |
|  [ Formal Verification ] ──► Mathematical proof of protocol correctness     |
|             ▲                                                               |
|             │                                                               |
|  [ Stateful Invariant Fuzzing ] ──► Random multi-call property testing      |
|             ▲                                                               |
|             │                                                               |
|  [ Stateless Fuzz Testing ] ──► Single-function randomized input testing    |
|             ▲                                                               |
|             │                                                               |
|  [ Unit & Integration Testing ] ──► Deterministic test scenarios            |
|             ▲                                                               |
|             │                                                               |
|  [ Static Analysis & Slither ] ──► AST & opcode pattern scanning            |
+-----------------------------------------------------------------------------+
```

---

## 2. Top Smart Contract Vulnerabilities & Mitigations

### 1. Reentrancy Attacks (The DAO Hack)
- **Vulnerability**: An external call (`msg.sender.call{value: ...}("")`) passes execution control to a malicious receiving contract's `receive()` or `fallback()` function before the state balance is updated.
- **Attack Flow**: Malicious contract recursively calls `withdraw()` repeatedly before its balance is set to 0.
- **Mitigation**:
  1. **Checks-Effects-Interactions (CEI)** pattern: Update internal state *before* interacting with external addresses.
  2. **ReentrancyGuard**: OpenZeppelin's `nonReentrant` modifier using a mutex storage flag.

```solidity
// Vulnerable:
function withdraw() public {
    uint256 balance = balances[msg.sender];
    (bool success, ) = msg.sender.call{value: balance}(""); // External call FIRST
    balances[msg.sender] = 0; // State change LAST (Too late!)
}

// Secure (CEI Pattern):
function withdraw() public {
    uint256 balance = balances[msg.sender];
    balances[msg.sender] = 0; // State change FIRST
    (bool success, ) = msg.sender.call{value: balance}(""); // External call LAST
    require(success, "Transfer failed");
}
```

---

### 2. Oracle Manipulation & Flash Loan Exploits
- **Vulnerability**: Relying on decentralized exchange spot prices (e.g. `reserve0 / reserve1` from an AMM pool) as a price oracle.
- **Attack Flow**: An attacker borrows $100\text{M}$ via a Flash Loan, executes a massive swap to skew the AMM pool reserves, borrows funds from the lending protocol at the manipulated price, and repays the flash loan in the same transaction.
- **Mitigation**:
  - Use decentralized, tamper-proof oracles like **Chainlink Price Feeds**.
  - Use Time-Weighted Average Prices (TWAP) across multiple blocks if querying on-chain liquidity pools.

---

### 3. Precision Loss & Division Before Multiplication
- **Vulnerability**: Integer division in Solidity truncates decimals towards zero ($1 / 2 = 0$).
- **Attack / Bug**: Executing division before multiplication causes severe precision loss in reward and fee calculations:
  ```solidity
  // Buggy: (10 / 100) * 50 = 0 * 50 = 0
  uint256 fee = (amount / feePrecision) * feeRate;

  // Correct: (10 * 50) / 100 = 500 / 100 = 5
  uint256 fee = (amount * feeRate) / feePrecision;
  ```

---

### 4. Storage Collisions & Uninitialized Proxies
- **Vulnerability**: In upgradeable proxy contracts, declaring a new state variable in a different order than the parent contract overwrites existing storage slots.
- **Mitigation**:
  - Adhere strictly to **ERC-1967** standardized storage slots.
  - Never change the inheritance order or modify the type/sequence of declared storage variables across implementation upgrades.

---

## 3. Stateful Invariant & Property-Based Fuzz Testing

- **Stateless Fuzzing**: Feeds random inputs into a single isolated function (e.g. testing if `sqrt(x) * sqrt(x) <= x` for any uint256).
- **Stateful (Invariant) Fuzzing**: Executes random sequences of multiple function calls (`deposit -> mint -> swap -> withdraw`) across millions of permutations to ensure system-wide **invariants** never break.

### Core Protocol Invariants Tested in this Repository:
1. **DSCEngine Solvency**:
   $$\sum \text{Collateral Value in USD} \ge \sum \text{Total DSC Minted}$$
2. **CPAMM Constant Product**:
   $$\text{reserve0} \times \text{reserve1} \ge k_{\text{initial}}$$
3. **ERC-20 Token Accounting**:
   $$\sum_{i} \text{balanceOf}(i) = \text{totalSupply}$$

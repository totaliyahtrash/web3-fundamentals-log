# Notes: Gas Mechanics, EIP-1559 & The Mempool

*Course Reference: Cyfrin Updraft - Blockchain Basics*

---

## 1. Why Gas Exists
Gas is the internal unit of measurement for computational work and storage required to process transactions and execute smart contracts on Ethereum.

**Primary Purposes:**
1. **Prevent the Halting Problem / Infinite Loops**: Without gas, a malicious or buggy transaction could run an infinite loop and freeze the entire network.
2. **Resource Allocation**: Compensates validators for processing transactions and incentivizes network capacity management.

---

## 2. Gas Units vs. Gas Price

| Term | Meaning | Typical Example |
|---|---|---|
| **Gas Units (Gas Limit)** | Quantity of computational work required | `21,000` for standard ETH transfer |
| **Gas Price (Gwei)** | Cost per unit of gas ($1 \text{ Gwei} = 10^{-9} \text{ ETH} = 10^9 \text{ Wei}$) | `15 Gwei` |
| **Total Transaction Fee** | $\text{Gas Used} \times \text{Effective Gas Price}$ | $21,000 \times 15\text{ Gwei} = 0.000315\text{ ETH}$ |

---

## 3. The EIP-1559 Fee Market Mechanism

Since the London Hard Fork (EIP-1559), transaction fees are split into two components:

$$\text{Gas Fee} = \text{Gas Used} \times (\text{Base Fee} + \text{Priority Fee})$$

1. **Base Fee**:
   - Set algorithmically by protocol based on block fullness compared to the target block size ($15\text{M}$ gas target, $30\text{M}$ gas max).
   - If previous block $> 50\%$ full $\rightarrow$ Base Fee increases (up to $+12.5\%$).
   - If previous block $< 50\%$ full $\rightarrow$ Base Fee decreases (up to $-12.5\%$).
   - **Crucially: Base fee is BURNED, removing ETH from circulation.**
2. **Priority Fee (Tip)**:
   - Optional tip paid directly to the block builder/validator to incentivize inclusion.
3. **Max Fee**:
   - The absolute maximum fee per unit of gas the sender is willing to pay.
   - Any difference between $\text{Max Fee}$ and $(\text{Base Fee} + \text{Priority Fee})$ is refunded to the sender.

---

## 4. Nonces and Mempool Ordering

- A **nonce** is an incrementing integer representing the number of transactions sent from an address.
- Nonces must be executed **in exact sequential order** ($0, 1, 2, \dots$).
- **Transaction Replacement (Speed Up / Cancel)**:
  - If a transaction with nonce `N` is pending in the mempool due to low gas, sending a new transaction with the **same nonce `N`** and at least $+10\%$ higher gas fee will replace the old transaction in the mempool.

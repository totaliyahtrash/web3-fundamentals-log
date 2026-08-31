# Notes: Blockchain & EVM Fundamentals

*Course Reference: Cyfrin Updraft - Blockchain Basics*

---

## 1. What is a Blockchain?
A blockchain is a decentralized, cryptographically secure, append-only distributed ledger maintained by a peer-to-peer network of nodes without relying on a central authority.

```
+-------------+         +-------------+         +-------------+
|   Block N   | <------ |  Block N+1  | <------ |  Block N+2  |
| Prev: 0x000 |         | Prev: 0x4a1 |         | Prev: 0x9f3 |
| State Root  |         | State Root  |         | State Root  |
| Tx Data     |         | Tx Data     |         | Tx Data     |
+-------------+         +-------------+         +-------------+
```

### Core Properties
1. **Decentralization**: No single point of failure; consensus is reached across thousands of global nodes.
2. **Immutability**: Once a transaction is included and finalized in a block, modifying historical data requires re-mining/re-attesting all subsequent blocks, which is economically unfeasible.
3. **Transparency**: Every transaction, balance, and smart contract interaction is publicly verifiable on block explorers.

---

## 2. Cryptographic Building Blocks

### Cryptographic Hash Functions (Keccak-256)
- **Deterministic**: The same input will always produce the exact same 32-byte output.
- **Pre-image resistant (One-way)**: Given a hash $H$, it is computationally impossible to find the original message $M$ such that $\text{hash}(M) = H$.
- **Collision resistant**: Extremely difficult to find two distinct messages $M_1 \neq M_2$ with $\text{hash}(M_1) = \text{hash}(M_2)$.
- **Avalanche Effect**: A single bit change in the input drastically and unpredictably changes the entire output hash.

### Public-Key Cryptography (ECDSA secp256k1)
- Used to digitally sign transactions.
- Allows anyone to verify that the transaction was authorized by the owner of the private key without ever exposing the private key itself.

---

## 3. The EVM (Ethereum Virtual Machine) State Machine
Ethereum is not just a ledger of balances; it is a decentralized computer with global state.

- **World State**: A mapping of addresses to account states (`nonce`, `balance`, `storageRoot`, `codeHash`).
- **Externally Owned Accounts (EOAs)**: Controlled by private keys (users). Have no contract code.
- **Contract Accounts (Smart Contracts)**: Controlled by deployed bytecode stored on-chain. Can hold funds, execute logic, and modify their own internal storage.

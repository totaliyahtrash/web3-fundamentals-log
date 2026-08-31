# Activity 03: Executing & Dissecting My First Testnet Transaction

**Date:** [YYYY-MM-DD]  
**Network:** Sepolia Testnet (`Chain ID: 11155111`)  
**Transaction Type:** Native ETH Transfer (EOA to EOA)

---

## 🎯 Objectives
- Initiate, sign, and broadcast an outbound transaction from `Account 1` to `Account 2`.
- Observe transaction state changes from Mempool $\rightarrow$ Mined $\rightarrow$ Confirmed.
- Break down the raw cryptographic signature and gas fees on Etherscan.

---

## 📝 Transaction Record

| Parameter | Data |
|---|---|
| **Status** | ✅ Confirmed (Success) |
| **Transaction Hash** | `0x[PASTE_YOUR_TX_HASH_HERE]` |
| **From (Sender)** | `0x[YOUR_ACCOUNT_1_ADDRESS]` |
| **To (Recipient)** | `0x[YOUR_ACCOUNT_2_ADDRESS]` |
| **Value Transferred** | `0.05 Sepolia ETH` |
| **Nonce** | `0` (First outbound transaction for this account) |
| **Gas Limit** | `21,000` |
| **Gas Used by Tx** | `21,000` (100% of allocation) |
| **Base Fee** | `0.000000007 ETH` (7 Gwei) |
| **Priority Fee (Tip)** | `1.0 Gwei` |
| **Total Gas Paid** | `0.000168 Sepolia ETH` |
| **Explorer Link** | `https://sepolia.etherscan.io/tx/0x[PASTE_YOUR_TX_HASH_HERE]` |

---

## 🔬 Technical Breakdown of What Happened

### 1. Signature Generation ($r, s, v$)
When I clicked **Confirm** in my wallet:
- The wallet constructed the unsigned RLP-encoded transaction object.
- It computed the Keccak-256 hash of this payload.
- It signed the hash with my account's private key using ECDSA, outputting three values:
  - $r$: The x-coordinate of the ephemeral public key point.
  - $s$: The signature proof value.
  - $v$: The recovery identifier (incorporating EIP-155 replay protection: $v = 2 \times \text{ChainId} + 35 + \text{recoveryBit}$).

### 2. Mempool Propagation
- The signed transaction was sent to an RPC node (Infura / Alchemy) via the `eth_sendRawTransaction` method.
- Nodes in the peer-to-peer network validated the signature and nonce, then held the transaction in their local memory pool (mempool).

### 3. Block Inclusion & State Transition
- A validator selected the transaction from the mempool, packaged it into a proposed block, and executed the EVM state change:
  $$\text{Balance}(\text{From}) \leftarrow \text{Balance}(\text{From}) - \text{Value} - \text{GasFee}$$
  $$\text{Balance}(\text{To}) \leftarrow \text{Balance}(\text{To}) + \text{Value}$$
  $$\text{Nonce}(\text{From}) \leftarrow \text{Nonce}(\text{From}) + 1$$

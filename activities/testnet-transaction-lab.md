# 🧪 Hands-On Lab: Wallet Setup, Faucet Funding & Transaction Dissection

*Curriculum: Cyfrin Updraft | Environment: Ethereum Sepolia (`Chain ID: 11155111`)*

---

## 🎯 Lab Objectives
1. Safely initialize an isolated developer wallet using standard derivation paths (`m/44'/60'/0'/0/0`).
2. Acquire testnet liquidity via PoS/PoW faucets without exposing personal infrastructure.
3. Broadcast an outbound native ETH transaction and dissect the raw cryptographic signature, gas parameters, and state transitions.

---

## 🔐 Part 1: Developer Wallet Configuration & Key Hygiene

### Security Rules Enforced:
- **Zero Mainnet Contamination**: Created a dedicated developer wallet (Rabby Wallet / MetaMask) containing zero mainnet assets.
- **Secret Isolation**: Seed phrases and private keys are never stored in plaintext, tracked in Git, or pasted into untrusted browser tabs.
- **Chain ID Validation**: Explicitly verified the Sepolia RPC endpoint (`11155111`) to prevent replay attack vulnerability on alternative networks.

---

## 💧 Part 2: Faucet Acquisition Mechanics

Testnet faucets provide free testnet ETH to cover the computational gas required for EVM execution.

```
[ Developer Address ] ──► [ Sepolia Faucet Endpoint ] 
                                  │ (Validates PoW Captcha / Gitcoin Passport)
                                  ▼
[ Mempool Broadcast ] ──► [ Block Inclusion ] ──► [ +0.50 Sepolia ETH Balance ]
```

### Inbound Faucet Transaction Analysis:
- **Transaction Type**: Native EIP-1559 ETH Transfer
- **Gas Limit**: `21,000` (100% used)
- **Fee Payer**: The faucet operator address (`from`), leaving the receiving account balance unburdened.
- **State Impact**: Receiver balance updated immediately upon block inclusion ($\approx 12\text{ seconds}$).

---

## 🔬 Part 3: Outbound Transaction Payload & Cryptographic Anatomy

A native transfer of `0.05 Sepolia ETH` was broadcasted from `Account A` to `Account B`.

### Raw Transaction Fields Inspected:

```json
{
  "nonce": 0,
  "gasLimit": "21000",
  "maxFeePerGas": "1500000000",
  "maxPriorityFeePerGas": "1000000000",
  "value": "50000000000000000",
  "chainId": 11155111,
  "data": "0x",
  "r": "0x8a3f...",
  "s": "0x4b7c...",
  "v": "22310257"
}
```

### Technical Findings:
1. **ECDSA Signature Recovery ($r, s, v$)**:
   - $r, s$: Proof of elliptic curve private key authorization.
   - $v$: Incorporates EIP-155 replay protection: $v = 2 \times 11155111 + 35 + 0 = 22310257$.
2. **EIP-1559 Fee Settlement**:
   $$\text{Total Fee} = 21,000 \times (\text{Base Fee} + \text{Priority Fee})$$
   The base fee was permanently burned by the EVM protocol, while the priority tip was awarded to the validating node proposer.
3. **Atomic State Mutation**:
   $$\text{Balance}(\text{Sender}) \leftarrow \text{Balance}(\text{Sender}) - \text{Value} - \text{TotalGasFee}$$
   $$\text{Balance}(\text{Recipient}) \leftarrow \text{Balance}(\text{Recipient}) + \text{Value}$$
   $$\text{Nonce}(\text{Sender}) \leftarrow \text{Nonce}(\text{Sender}) + 1$$

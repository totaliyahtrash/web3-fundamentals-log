# Activity 01: Wallet Setup & Security Architecture

**Date:** [YYYY-MM-DD]  
**Tool Used:** Rabby Wallet / MetaMask  
**Network Configured:** Ethereum Sepolia (`Chain ID: 11155111`)

---

## 🎯 Objectives
- Install a Web3 browser extension wallet.
- Generate a brand-new cryptographic keypair using a BIP-39 mnemonic seed phrase.
- Understand how public keys, private keys, and addresses relate to one another.
- Establish strict security hygiene for smart contract development.

---

## 🔐 Key Concepts Breakdown

### 1. Hierarchical Deterministic (HD) Wallets
A single 12- or 24-word seed phrase deterministically generates a master private key. From this master key, an infinite tree of child private keys and public addresses can be derived using standardized derivation paths:

$$\text{Seed Phrase} \xrightarrow{\text{PBKDF2}} \text{Master Seed} \xrightarrow{\text{HMAC-SHA512}} \text{Master Key} \xrightarrow{\text{BIP-44 Path}} \text{Ethereum Account}$$

- **Standard Ethereum Derivation Path**: `m/44'/60'/0'/0/0`
  - `44'` = BIP-44 purpose (multi-account hierarchy)
  - `60'` = Ethereum coin type (registered under SLIP-0044)
  - `0'` = Account index
  - `0` = Change chain (external / receiving)
  - `0` = Address index

### 2. Elliptic Curve Cryptography (`secp256k1`)
- **Private Key**: A 256-bit scalar integer $k \in [1, n-1]$.
- **Public Key**: Calculated as $K = k \times G$, where $G$ is the generator point on the `secp256k1` curve.
- **Ethereum Address**: The last 20 bytes of $\text{Keccak-256}(K_{\text{uncompressed}})$, prefixed with `0x`.

---

## 🛡️ Developer Security Rules Established

1. **Burner Wallet Isolation**:
   - The wallet created for testnet development is **never** used for personal funds or mainnet assets.
2. **Never Commit Secrets**:
   - Mnemonic phrases and raw private keys are never hardcoded into scripts or tracked in Git repositories.
   - `.env` files are strictly added to `.gitignore`.
3. **Phishing & RPC Awareness**:
   - Always verify the RPC URL and Chain ID when adding custom networks (`11155111` for Sepolia).

# Activity 02: Testnet Faucets & Funding Mechanics

**Date:** [YYYY-MM-DD]  
**Network:** Sepolia Testnet (`11155111`)  
**Faucet Source:** Google Cloud Web3 Faucet / Alchemy Sepolia Faucet / PoW Faucet  

---

## 🎯 Objectives
- Understand why testnets exist and how they emulate mainnet state transitions.
- Safely request and receive testnet ETH into my newly generated developer wallet.
- Trace the inbound faucet transaction on Etherscan.

---

## 💧 What are Faucets and How Do They Work?

In a testnet, ETH has **no economic value**, but it is still strictly required to pay for gas to prevent denial-of-service (DoS) spam attacks against node operators.

A faucet is an automated service (smart contract or custodial server) that:
1. Receives a user's wallet address.
2. Checks anti-abuse constraints (rate limits, Gitcoin Passport score, or PoW captcha).
3. Constructs and signs an Ethereum transaction sending $X$ amount of testnet ETH.
4. Broadcasts it to the Sepolia mempool.

---

## 📊 Inbound Transaction Details

| Field | Value / Record |
|---|---|
| **Recipient Address** | `0x[YOUR_WALLET_ADDRESS]` |
| **Transaction Hash** | `0x[FAUCET_TRANSACTION_HASH]` |
| **Block Number** | `[e.g., 5429182]` |
| **Amount Received** | `0.5 Sepolia ETH` |
| **Etherscan Explorer URL** | `https://sepolia.etherscan.io/tx/0x[YOUR_HASH]` |

---

## 🔍 Key Observations
- The incoming transfer was a standard native transfer with a `gasLimit` of `21,000`.
- The transaction fee was paid by the faucet operator's address (`from`), not by my receiving address.
- My address balance updated immediately upon block inclusion ($\approx 12\text{ seconds}$).

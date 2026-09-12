# 🛡️ Security Policy & Vulnerability Reporting

## Responsible Disclosure

Security is paramount in Web3 smart contract development. If you discover any potential security vulnerability within this repository, please report it responsibly rather than opening a public issue.

### Reporting a Vulnerability

1. **Email**: Send detailed vulnerability reports to `security@totaliyahtrash.dev` (or reach out privately on GitHub/Twitter).
2. **Details to Include**:
   - Description of the vulnerability and attack vector.
   - Proof of Concept (PoC) Foundry test script reproducing the issue.
   - Assessment of potential impact (e.g., loss of funds, denial of service, griefing).

---

## 🔐 Core Security Practices Implemented

- **Checks-Effects-Interactions (CEI)** pattern strictly enforced across state-mutating functions.
- **Custom Errors (EIP-838)** preventing expensive string revert payloads.
- **ERC-1967 Collision-Resistant Storage Slots** on all upgradeable proxy implementations.
- **Stateful Invariant Fuzz Testing** ensuring protocol solvency under all randomized interaction sequences.
- **Zero Secret Storage**: Private keys and seed phrases are excluded from version control via `.gitignore`.

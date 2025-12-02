# ojcoin Clarinet Project

This directory contains the **ojcoin** smart contract, implemented in [Clarity](https://docs.stacks.co/write-smart-contracts/clarity-overview) and managed with [Clarinet](https://docs.hiro.so/clarinet).

The contract lives in `contracts/ojcoin.clar` and implements a simple fungible-style token with a fixed supply that is minted to the deployer on initialization.

---

## Project Layout

- `Clarinet.toml` – Clarinet project configuration
- `contracts/ojcoin.clar` – OJCoin smart contract
- `tests/ojcoin.test.ts` – Contract unit test scaffold (TypeScript)
- `settings/*.toml` – Network configuration templates (Devnet, Testnet, Mainnet)
- `.vscode/` – Recommended VS Code tasks and settings

---

## Requirements

- **Node.js** (for running tests via `npm` / `pnpm`, optional)
- **Clarinet** (Stacks smart contract development tool)

Clarinet is already installed on this machine (verified via `clarinet --version`). If you need to install it elsewhere, follow the official docs:
https://docs.hiro.so/clarinet/how-to-guides/how-to-set-up-local-development-environment

---

## OJCoin Contract Overview

The OJCoin contract is a minimal example of a fungible token with:

- A **fixed total supply** defined at compile time.
- **Initialization** that mints the entire supply to the transaction sender (typically the deployer) via `initialize`.
- A basic **transfer** function to move balances between principals.
- Read-only helpers to query balances and total supply.

### Key Concepts

- **Total supply**: `OJCOIN-TOTAL-SUPPLY` constant.
- **Balances**: Stored in the `balances` map (`principal -> uint`).
- **Initialization**: May only be successfully called once, when `total-supply` is still `u0`.

### Main Functions

- `initialize` (public)
  - Mints the full `OJCOIN-TOTAL-SUPPLY` to `tx-sender`.
  - Can only be called once (subsequent calls return an authorization error).

- `transfer` (public)
  - Moves `amount` of tokens from `tx-sender` to a `recipient` principal.
  - Fails if `amount` is zero or the sender has insufficient balance.

- `balance-of` (read-only)
  - `balance-of (owner principal)` → returns the balance of `owner`.

- `get-total-supply` (read-only)
  - Returns the current `total-supply` value.

---

## Usage

All commands below assume you are in the **ojcoin Clarinet project directory**:

```bash
cd ojcoin-project
```

### 1. Check the Contract

Run Clarinet’s static checks (type-checking, analysis, etc.):

```bash
clarinet check
```

You should see output indicating that the `ojcoin` contract passed analysis.

### 2. Initialize the Token

In a Clarinet console / REPL session, you can simulate calls to the contract.

Start the console:

```bash
clarinet console
```

Inside the console, call `initialize` once from the deployer account (usually `deployer`):

```scheme
(contract-call? .ojcoin initialize)
```

Then you can query balances:

```scheme
(contract-call? .ojcoin balance-of tx-sender)
(contract-call? .ojcoin get-total-supply)
```

> Note: In the console, `tx-sender` and standard signers like `deployer` can be set using Clarinet’s tooling.

### 3. Transfer Tokens

After initialization, you can simulate transfers in the console. For example, assuming you’ve set principals appropriately:

```scheme
(contract-call? .ojcoin transfer u100 'ST2J...RECIPIENT)
```

Then verify balances with:

```scheme
(contract-call? .ojcoin balance-of 'ST2J...RECIPIENT)
```

---

## Running Tests (Optional)

A basic TypeScript test scaffold exists at `tests/ojcoin.test.ts`.

Install dependencies (only required if you want to write and run JS/TS tests):

```bash
cd ojcoin-project
npm install
```

Run tests:

```bash
npm test
```

You can expand `tests/ojcoin.test.ts` with scenarios for:

- Successful initialization
- Double initialization failure
- Successful transfers
- Transfers with insufficient balance
- Zero-amount transfer error

---

## Top-Level Repository Notes

At the root of this repository (`/home/anthony/Documents/GitHub/ojcoin`), there is a minimal `README.md`. The Clarinet-specific project files and documentation live in `ojcoin-project/`.

You can link or summarize this README from the root-level README if desired.
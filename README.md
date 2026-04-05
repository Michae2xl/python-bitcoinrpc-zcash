# python-bitcoinrpc-zcash

Zcash fork of [python-bitcoinrpc](https://github.com/jgarzik/python-bitcoinrpc) with **Orchard shielded transactions** (Halo2, no trusted setup).

Automated migration by [Zcash Migrate](https://github.com/Michae2xl/zcash-migrate).

## Migration Stats

| Metric | Value |
|--------|-------|
| Original | [jgarzik/python-bitcoinrpc](https://github.com/jgarzik/python-bitcoinrpc) |
| Language | Python |
| Source files | 7 |
| RPC calls detected | 0 |
| Code changes applied | 19 |
| Framework | python-package |
| RPC calls mapped | 0 |
| Shielded methods |  |

## Quick Start

```python
from zcash_rpc import ZcashClient

client = ZcashClient(zebra_port=8232, zkool_port=8000)

# Chain data (via zebrad)
info = client.chain.getblockchaininfo()

# Shielded wallet (via zkool — Orchard/Halo2)
balance = client.wallet.get_balance(account_id)
addrs = client.wallet.get_addresses(account_id, pools=6)
txid = client.wallet.send(account_id, [{"address": addrs["ua"], "amount": "0.1"}], src_pools=4)
```

## What Changed

| Before (Bitcoin) | After (Zcash) |
|-----------------|---------------|
| `bitcoin/` module | `zcash/` module |
| `CBitcoinAddress` | `CZcashAddress` |
| Port 8332/8333 | Port 8232/8233 |
| `bitcoin-cli`, `bitcoind` | `zcash-cli`, `zcashd` |
| `~/.bitcoin/` | `~/.zcash/` |
| BTC, satoshis | ZEC, zatoshis |
| Public transactions | Shielded (Orchard/Halo2, zero-knowledge) |

## Generated Files

| File | Purpose |
|------|---------|
| `zcash-enhancements/zcash_rpc.py` | ZcashClient (ZebraRPC + ZkoolWallet) |
| `zcash-enhancements/test_zcash_rpc.py` | Test suite for zebrad + zkool |
| `zcash-enhancements/MIGRATION-MAP.md` | 0 RPC calls mapped to Zcash |
| `zcash-enhancements/ZK-GUIDE.md` | Integration guide with examples |
| `zcash-deploy/` | Node config + setup scripts |
| `NOTICE` | Open source attribution |

## Requirements

| Service | Port | Purpose |
|---------|------|---------|
| [zebrad](https://github.com/ZcashFoundation/zebra) | 8232 | Chain data (blocks, transactions, validation) |
| [zkool](https://github.com/hhanh00/zkool2) | 8000 | Wallet (accounts, send, shield, Orchard/Halo2) |

## License

Original code: see LICENSE (preserved from upstream project)
Zcash enhancements: MIT (see zcash-enhancements/LICENSE)
See NOTICE for full attribution.

## How to Test

### 1. Verify the wrapper loads

```bash
git clone https://github.com/Michae2xl/python-bitcoinrpc-zcash.git
cd python-bitcoinrpc-zcash/zcash-enhancements
python3 -c "from zcash_rpc import ZcashClient; print('Wrapper OK')"
```

This confirms the ZcashClient wrapper (ZebraRPC + ZkoolWallet) imports correctly. No node required for this step.

### 2. Test against a live Zcash node

If you have zebrad running:

```bash
cd zcash-enhancements
python3 -c "
from zcash_rpc import ZcashClient
c = ZcashClient(zebra_host='127.0.0.1', zebra_port=8232)
info = c.chain.getblockchaininfo()
print(f'Chain: {info[\"chain\"]}net, Block: {info[\"blocks\"]}')
"
```

### 3. Test wallet operations (requires zkool)

If you have zebrad + zkool running:

```bash
python3 -c "
from zcash_rpc import ZcashClient
c = ZcashClient(zebra_host='127.0.0.1', zebra_port=8232, zkool_host='127.0.0.1', zkool_port=8000)

# Chain
info = c.chain.getblockchaininfo()
print(f'Block: {info[\"blocks\"]}')

# Wallet
bal = c.wallet.get_balance(1)
print(f'Balance: {bal}')
"
```

### 4. Run your own migration

Want to migrate a different Bitcoin project? Use the migration tool:

```bash
git clone https://github.com/Michae2xl/zcash-migrate.git
cd zcash-migrate
npm install
npm run dev
# Open http://localhost:3000 and paste any Bitcoin GitHub repo
```

### Node Setup

| Service | Install | Purpose |
|---------|---------|---------|
| [zebrad](https://github.com/ZcashFoundation/zebra) | `cargo install --locked --git https://github.com/ZcashFoundation/zebra zebrad` | Chain data |
| [zkool](https://github.com/hhanh00/zkool2) | `cargo install --locked --git https://github.com/hhanh00/zkool2 --features=graphql zkool_graphql` | Wallet (Orchard/Halo2) |

Testnet faucet: https://testnet.zecfaucet.com/

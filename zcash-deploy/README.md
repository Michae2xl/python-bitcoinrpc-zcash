# Zcash Local Deployment

## Architecture

```
Your App → ZcashClient (zcash-enhancements/zcash_rpc.*)
              ├── ZebraRPC  → zebrad :8232 (chain data)
              └── ZkoolWallet → zkool_graphql :8000 (wallet ops, Orchard/Halo2)
```

## Quick Start

```bash
# 1. Verify connections
cd zcash-deploy && ./setup.sh

# 2. Run tests against your node
cd ../zcash-enhancements && pytest test_zcash_rpc.py -v

# 3. Use in your code
from zcash_rpc import ZcashClient
client = ZcashClient(zebra_port=8232, zkool_port=8000)
info = client.chain.getblockchaininfo()
addr = client.wallet.get_addresses(account_id=1)
```

## Requirements

| Service | Port | Purpose |
|---------|------|---------|
| zebrad | 8232 | Chain data (blocks, transactions, mempool) |
| zkool_graphql | 8000 | Wallet ops (accounts, send, shield, Orchard) |

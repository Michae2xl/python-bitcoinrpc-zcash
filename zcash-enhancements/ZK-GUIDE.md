# ZK Integration Guide

## Generated Files

| File | Purpose |
|------|---------|
| `zcash_rpc.py` | Full Zcash RPC client with z_* methods |
| `test_zcash_rpc.py` | Test suite — run against zcashd testnet |
| `MIGRATION-MAP.md` | Every Bitcoin RPC call mapped to Zcash equivalent |

## How to Use

### 1. Start zcashd testnet

```bash
zcashd -testnet -daemon
# Wait for sync, then:
zcash-cli -testnet getblockchaininfo
```

### 2. Replace Bitcoin RPC calls

```python
# Before:
from bitcoin.rpc import RawProxy
rpc = RawProxy(port=18332)
balance = rpc.getbalance()

# After:
from zcash_rpc import ZcashRPC
rpc = ZcashRPC(port=18232)
balance = rpc.z_gettotalbalance()  # {"transparent": "...", "private": "...", "total": "..."}
```

### 3. Shielded send (zk-SNARK transaction)

```python
rpc = ZcashRPC(port=18232)
zaddr = rpc.z_getnewaddress("sapling")  # zs... address

# Send privately (async — proof generation takes ~2s)
txid = rpc.shielded_send(
    from_addr=zaddr,
    to_addr="zs1recipient...",
    amount=1.0,
    memo="Private payment"
)
print(f"Shielded tx: {txid}")
```

### 4. Auto-shield (move transparent → shielded)

```python
taddr = rpc.getnewaddress()           # Transparent t-address
zaddr = rpc.z_getnewaddress("sapling") # Shielded z-address
opid = rpc.auto_shield(taddr, zaddr)
if opid:
    result = rpc.wait_for_operation(opid)
    print(f"Shielded: {result}")
```

### 5. Run tests

```bash
# Start zcashd testnet first, then:
cd zcash-enhancements && pytest test_zcash_rpc.py -v
```

## Address Types

| Type | Prefix (mainnet) | Prefix (testnet) | Privacy |
|------|-----------------|-------------------|---------|
| Transparent | t1... / t3... | tm... / t2... | Public |
| Sapling | zs... | ztestsapling... | zk-SNARK shielded |
| Unified | u1... | utest1... | Auto-selects best pool |

## How zk-SNARKs Work in Zcash

When you call `z_sendmany`, zcashd:
1. Selects shielded notes (like UTXOs but encrypted)
2. Generates a **zero-knowledge proof** (Groth16 for Sapling)
3. The proof proves the transaction is valid **without revealing** sender, recipient, or amount
4. Only the recipient can decrypt the transaction details
5. Proof generation takes ~2 seconds (CPU-intensive)

The proof is verified by every node, but reveals nothing about the transaction.

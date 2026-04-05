#!/bin/bash
set -e

echo "=== Zcash Local Setup ==="
echo ""

# 1. Check zebrad
echo "Checking zebrad..."
if curl -s --max-time 3 -X POST http://${ZEBRA_HOST:-127.0.0.1}:${ZEBRA_PORT:-8232} \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"getblockchaininfo","params":[]}' | grep -q '"chain"'; then
  echo "  zebrad: CONNECTED"
else
  echo "  zebrad: NOT FOUND"
  echo "  Install: https://github.com/ZcashFoundation/zebra"
  echo "  Or: docker run -p 8232:8232 zfnd/zebra"
fi

# 2. Check zkool
echo ""
echo "Checking zkool..."
if curl -s --max-time 3 -X POST http://${ZKOOL_HOST:-127.0.0.1}:${ZKOOL_PORT:-8000}/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"{ apiVersion }"}' | grep -q 'apiVersion'; then
  echo "  zkool: CONNECTED"
else
  echo "  zkool: NOT FOUND"
  echo "  Install: https://github.com/hhanh00/zkool2"
  echo "  Binary: zkool_graphql --port 8000"
fi

# 3. Validate wrapper
echo ""
echo "Testing Zcash RPC wrapper..."
cd ../zcash-enhancements
python3 -c "from zcash_rpc import ZcashClient; print('  Wrapper: OK')"

echo ""
echo "=== Setup Complete ==="
echo "Project: fix-pythonbitcoinrpc"
echo "Wrapper: zcash-enhancements/zcash_rpc.py"
echo "Tests:   zcash-enhancements/test_zcash_rpc.py"
echo ""
echo "Next steps:"
echo "  1. Review zcash-enhancements/MIGRATION-MAP.md"
echo "  2. Replace Bitcoin imports with ZcashClient"
echo "  3. Run tests: cd zcash-enhancements && pytest test_zcash_rpc.py -v"

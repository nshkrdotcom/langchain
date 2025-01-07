
#!/bin/bash

# 1. Update run_tests.sh to default to verbose
sed -i 's/VERBOSE=false/VERBOSE=true/' run_tests.sh

# 2. Add run_tests.sh usage to README.md
echo '
### Test Execution

```bash
# Run tests with verbose output (default)
./run_tests.sh

# Run tests without verbose output
./run_tests.sh --no-verbose
```
' >> README.md

# 3. Fix unused alias warning
sed -i '/alias LangChain.Chains.Base.Chain/d' test/unit/langchain/chains/base/chain_test.exs

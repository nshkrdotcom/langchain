#!/bin/bash
chmod +x r.sh
./r.sh
mix deps.get
mix test test/unit/provider_layer/providers/gemini/provider_test.exs --include live_call | copy
git add .
git commit --m 'fb'
git push

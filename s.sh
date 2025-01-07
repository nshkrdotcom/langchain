#!/bin/bash
chmod +x r.sh
./r.sh
mix deps.get
mix test test/unit/provider_layer/providers/gemini/provider_test.exs --include live_call  2>&1 | tee >(xclip -selection clipboard)
git add .
git commit --m 'fb'
git push
rm r.sh
#nano r.sh

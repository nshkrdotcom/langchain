
#!/bin/bash

# Run the specific Gemini provider test with live call tag
echo "Running Gemini Provider E2E test..."
mix test test/unit/provider_layer/providers/gemini/provider_test.exs --include live_call --trace

# Capture the exit code
TEST_EXIT_CODE=$?

if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo "✅ Gemini Provider E2E test passed"
else
    echo "❌ Gemini Provider E2E test failed"
fi

exit $TEST_EXIT_CODE


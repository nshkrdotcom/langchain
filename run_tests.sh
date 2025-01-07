#!/bin/bash

# Parse command line arguments
VERBOSE=true

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -v|--verbose) VERBOSE=true ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# Set environment variable based on verbose flag
export TEST_VERBOSE=$VERBOSE

# Run tests with proper configuration
if [ "$VERBOSE" = true ]; then
    echo "Running tests in verbose mode..."
    mix test --trace
else
    echo "Running tests in normal mode..."
    mix test
fi

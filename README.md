
# LangChain Test Suite

## Test Organization

```
test/
├── integration/      # End-to-end tests
├── unit/            # Unit tests
└── support/         # Test helpers and fixtures
```

## Running Tests

### Basic Test Commands

```bash
# Run all tests (excluding live API calls)
mix test

# Run specific test file
mix test test/unit/provider_layer/providers/gemini/provider_test.exs

# Run specific test line
mix test test/unit/provider_layer/providers/gemini/provider_test.exs:42
```

### Test Tags

Tests are organized with tags for selective running:

```bash
# Run only unit tests
mix test test/unit

# Run only integration tests
mix test test/integration

# Run tests with live API calls
mix test --include live_call

# Run only chat-related tests
mix test --include chat

# Run provider-specific tests
mix test --include provider:gemini
mix test --include provider:openai
```

### Test Environment

The test environment is configured in `config/config.exs`. Make sure you have:

1. Required dependencies installed (`mix deps.get`)
2. Test environment variables set (if testing with live APIs)

### Writing Tests

1. Use `LangChain.TestCase` as your base test module:

```elixir
defmodule YourTest do
  use LangChain.TestCase
  
  test "your test" do
    # test code
  end
end
```

2. Tag tests appropriately:

```elixir
@tag :live_call
@tag provider: :gemini
test "makes live API call" do
  # test code
end
```

### Test Fixtures

Fixtures are located in `test/support/fixtures/` and can be accessed via the `Fixtures` module in your tests.

# LangChain Testing Strategy

## Structure

- `unit/`: Unit tests for individual components
  - `provider_layer/`: Tests for provider implementations
  - `langchain/`: Tests for LangChain capabilities
- `integration/`: End-to-end flow tests
- `support/`: Test helpers and fixtures

## Running Tests

```bash
# Run all tests except live calls
mix test test3

# Run only unit tests
mix test test3/unit

# Run only integration tests
mix test test3/integration

# Run with live calls
mix test test3 --include live_call
```

## Test Development Process

1. Create unit tests for new providers in `unit/provider_layer/providers/`
2. Create unit tests for new capabilities in `unit/langchain/capabilities/`
3. Create integration tests in `integration/` for complete flows
4. Add fixtures to `support/fixtures/` as needed

## Test Tags

### @tag :live_call

Technical Definition:
- Indicates that the test will make actual HTTP requests to AI provider APIs
- Requires valid API credentials in the environment
- May incur costs based on provider pricing
- Tests real-world latency and response handling

Practical Usage:
```elixir
@tag :live_call
test "generates content using real API" do
  # Makes actual API call
end
```

### @tag :chat

Technical Definition:
- Tests chat-specific functionality and models
- Focuses on conversation flow and message handling
- May be combined with `:live_call` for end-to-end testing
- Tests chat-specific features like streaming, tool calls, and function execution

Practical Usage:
```elixir
@tag chat: true
@tag :live_call  # If making real API calls
test "handles multi-turn conversation" do
  # Chat-specific test logic
end
```

Run specific tag combinations:
```bash
# Run only chat tests
mix test --include chat

# Run live API tests
mix test --include live_call

# Run both chat and live tests
mix test --include chat --include live_call
```

## Best Practices

## Best Practices

- Use `LangChain.TestCase` as the base for all tests
- Tag live API calls with `@moduletag :live_call`
- Mock external services in unit tests
- Use fixtures for common test data

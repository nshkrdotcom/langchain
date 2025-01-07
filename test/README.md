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

## Best Practices

- Use `LangChain.TestCase` as the base for all tests
- Tag live API calls with `@moduletag :live_call`
- Mock external services in unit tests
- Use fixtures for common test data

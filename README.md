
## Gemini API Integration

LangChain provides integration with Google's Gemini API through the following modules:

### Basic Usage
```elixir
alias LangChain.Provider.Gemini.Provider

# Generate simple text content
{:ok, response} = Provider.generate_content("What is Elixir?")

# Generate structured JSON
{:ok, json_response} = Provider.generate_content("List 3 programming languages as JSON")
```

### API Structure

The Gemini integration uses a three-layer architecture:

1. **Provider Layer** (`Provider`): High-level interface for making Gemini API calls
2. **Generative Model** (`GenerativeModel`): Handles model-specific logic and validation
3. **Client** (`Client`): Low-level HTTP client for direct API communication

### Response Format

Successful responses follow this structure:
```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "Response text here"
          }
        ]
      }
    }
  ]
}
```

### Configuration

Set your Gemini API key in your config:
```elixir
# config/config.exs
config :langchain, :gemini_api_key, System.get_env("GEMINI_API_KEY")
```

### Error Handling

The API handles common errors:
- Invalid API key
- Rate limiting
- Malformed requests
- Invalid response formats

Errors are returned as `{:error, reason}` tuples with detailed error messages.

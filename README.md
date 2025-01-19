
## Gemini API Integration

LangChain provides integration with Google's Gemini API through the Provider module, supporting both basic text generation and structured output capabilities.

### Basic Usage

```elixir
alias LangChain.Provider.Gemini.GenerativeModel

# Simple text generation
{:ok, response} = Provider.generate_content("What is Elixir?")

# Generate structured JSON output
schema = %{
  type: :object,
  properties: %{
    languages: %{
      type: :array,
      items: %{
        type: :object,
        properties: %{
          name: %{type: :string},
          paradigm: %{type: :string},
          year_created: %{type: :number}
        }
      }
    }
  }
}

# Generate structured content
{:ok, json_response} = GenerativeModel.generate_content(
  "List 3 programming languages",
  structured_output: schema
)

### Verbose Logging

To enable verbose logging for debugging:

```elixir
# In config/config.exs
config :langchain, :log_level, :debug

# Or dynamically
Logger.configure(level: :debug)
```

### Response Handling

The provider handles different response types:
- Text responses: `{:ok, text}`
- Structured JSON: `{:ok, decoded_json}`
- Errors: `{:error, reason}`
```elixir
alias LangChain.Provider.Gemini.GenerativeModel

# Generate simple text content
{:ok, response} = GenerativeModel.generate_content("What is Elixir?")

# Generate structured JSON by force
{:ok, json_response} = GenerativeModel.generate_content("List 3 programming languages as JSON")

# Use Gemini's structured output feature
schema = %{
  type: "object",
  properties: %{
    languages: %{
      type: "array",
      items: %{
        type: "object",
        properties: %{
          name: %{type: "string"},
          paradigm: %{type: "string"},
          year_created: %{type: "number"}
        }
      }
    }
  }
}

{:ok, structured_response} = GenerativeModel.generate_content(
  "List 3 programming languages",
  structured_output: schema
)
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


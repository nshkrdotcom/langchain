
#!/bin/bash

# Fix generative_model.ex
cat > lib/provider_layer/providers/gemini/generative_model.ex << 'EOL'
defmodule LangChain.Google.GenerativeModel do
  @moduledoc """
  Provides functions for interacting with Google's Gemini models.
  """
  alias LangChain.Google.Client
  
  use LangChain.ChatModels.ChatModel,
    middleware: [
      LangChain.Middleware.ErrorMiddleware,
      LangChain.Middleware.LoggingMiddleware,
      LangChain.Middleware.PersistenceMiddleware
    ]

  # Function header with default value
  @spec generate_content(String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def generate_content(prompt, opts \\ [])

  # Actual implementation
  def generate_content(prompt, opts) do
    with {:ok, response} <- Client.generate_content(prompt, opts) do
      case Keyword.get(opts, :response_mime_type) do
        "application/json" -> {:ok, response}
        _ -> {:ok, response}
      end
    end
  end
end
EOL


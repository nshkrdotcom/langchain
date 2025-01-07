
#!/bin/bash

# Fix unused opts warning in client.ex
cat > lib/provider_layer/providers/gemini/client.ex << 'EOL'
defmodule LangChain.Google.Client do
  @spec generate_content(String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def generate_content(prompt, _opts \\ []) do
    {:ok, %{text: prompt}}
  end
end
EOL

# Fix multiple clauses warning in generative_model.ex
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

  @spec generate_content(String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def generate_content(prompt, opts \\ [])
  def generate_content(prompt, opts) when is_binary(prompt) do
    with {:ok, response} <- Client.generate_content(prompt, opts) do
      case Keyword.get(opts, :response_mime_type) do
        "application/json" -> {:ok, response}
        _ -> {:ok, response}
      end
    end
  end
end
EOL

# Fix test case redefinition
cat > test/support/test_case.ex << 'EOL'
defmodule LangChain.TestCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use ExUnit.Case
      import LangChain.TestCase
    end
  end
end
EOL


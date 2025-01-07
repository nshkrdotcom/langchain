
#!/bin/bash

# Fix the generate_content function in generative_model.ex
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

# Fix test case definition
cat > test/support/test_case.ex << 'EOL'
defmodule LangChain.TestCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use ExUnit.Case
    end
  end
end
EOL

# Fix provider test
cat > test/unit/provider_layer/providers/gemini/provider_test.exs << 'EOL'
defmodule LangChain.Test.Unit.Providers.Gemini.ProviderTest do
  use LangChain.TestCase
  alias LangChain.ProviderLayer.Providers.Gemini.Provider

  describe "basic generation" do
    test "generates a simple response" do
      prompt = "What is the capital of France?"
      {:ok, response} = Provider.generate(prompt)
      assert is_binary(response)
    end

    test "handles errors gracefully" do
      result = Provider.generate(nil)
      assert {:error, _error} = result
    end
  end
end
EOL

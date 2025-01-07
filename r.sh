
#!/bin/bash

# Update the Gemini Provider to include the generate/1 function
cat > lib/provider_layer/providers/gemini/provider.ex << 'EOL'
defmodule LangChain.ProviderLayer.Providers.Gemini.Provider do
  @behaviour LangChain.Provider
  alias LangChain.Google.GenerativeModel

  @impl LangChain.Provider
  def generate_content(prompt, opts \\ []) do
    case GenerativeModel.generate_content(prompt, opts) do
      {:ok, response} -> {:ok, response.text}
      error -> error
    end
  end

  @doc """
  Simplified generate function that matches the test expectations
  """
  def generate(nil), do: {:error, "Prompt cannot be nil"}
  def generate(prompt) when is_binary(prompt) do
    generate_content(prompt)
  end
end
EOL


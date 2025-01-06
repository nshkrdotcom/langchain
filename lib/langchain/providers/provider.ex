# lib/langchain/provider.ex (Abstract behaviour)
defmodule LangChain.Provider do
  @moduledoc "Defines the common interface for all AI model providers"

  @callback generate_content(prompt :: String.t(), opts :: keyword()) ::
              {:ok, map()} | {:error, Exception.t()}

  @callback stream_generate_content(prompt :: String.t(), opts :: keyword()) ::
              {:ok, Enumerable.t()} | {:error, Exception.t()}

  @callback embed_content(content :: String.t() | list(String.t()), opts :: keyword()) ::
              {:ok, list(float())} | {:error, Exception.t()}

  # ... other common functions ...
end

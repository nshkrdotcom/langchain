defmodule LangChain.Provider.Behavior do
  @callback generate_content(String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  @callback stream_content(String.t(), keyword()) :: {:ok, Enumerable.t()} | {:error, term()}
  @callback generate_embeddings(String.t(), keyword()) :: {:ok, list(float())} | {:error, term()}
end

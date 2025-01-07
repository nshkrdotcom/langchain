defmodule LangChain.Provider.HTTP.Client do
  @callback post(String.t(), map(), keyword()) :: {:ok, map()} | {:error, term()}
  @callback stream_post(String.t(), map(), keyword()) :: {:ok, Enumerable.t()} | {:error, term()}
end

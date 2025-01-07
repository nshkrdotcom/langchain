
defmodule LangChain.Persistence.StorageBehavior do
  @callback store_interaction(map()) :: {:ok, map()} | {:error, term()}
  @callback retrieve_interaction(String.t()) :: {:ok, map()} | {:error, term()}
  @callback list_interactions(map()) :: {:ok, [map()]} | {:error, term()}
  @callback delete_interaction(String.t()) :: {:ok, String.t()} | {:error, term()}
end

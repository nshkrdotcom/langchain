defmodule LangChain.Middleware.Behaviour do
  @moduledoc """
  Defines the contract for middleware in LangChain.
  """

  @callback handle_request(context :: map(), next :: (map() -> map())) :: map()
end





defmodule LangChain.Middleware.Behaviour do
  @callback handle(map(), function()) :: {:ok, map()} | {:error, term()}
end

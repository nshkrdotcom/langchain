defmodule LangChain.Middleware.Behaviour do
  @callback handle_request(context :: map(), next :: function()) :: {:ok, map()} | {:error, any()}
end

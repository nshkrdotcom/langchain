# lib/langchain/middleware/middleware_behavior.ex
defmodule LangChain.Middleware.MiddlewareBehavior do
  @moduledoc """
  Defines the behavior for LangChain middleware.
  """

  @callback handle_request(context :: map(), next :: (map() -> map())) :: map()
  @callback handle_response(context :: map(), next :: (map() -> map())) :: map()
end

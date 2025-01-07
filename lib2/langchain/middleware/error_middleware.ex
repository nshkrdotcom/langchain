# lib/langchain/middleware/error_middleware.ex
defmodule LangChain.Middleware.ErrorMiddleware do
  @moduledoc """
  Middleware for handling errors in LangChain interactions.
  """
  @behaviour LangChain.Middleware.MiddlewareBehavior
  alias LangChain.Error

  def handle_request(context, next) do
    try do
      next.(context)
    rescue
      e ->
        # Log the error
        IO.inspect(e, label: "Error")

        # Convert to a standard LangChain error
        new_context = Map.put(
          context,
          :error,
          Error.exception(:middleware_error, "An error occurred in a middleware", %{
            original_error: e
          })
        )

        new_context
    end
  end

  def handle_response(context, next) do
    try do
      next.(context)
    rescue
      e ->
        # Log the error
        IO.inspect(e, label: "Error")

        # Convert to a standard LangChain error
        new_context = Map.put(
          context,
          :error,
          Error.exception(:middleware_error, "An error occurred in a middleware", %{
            original_error: e
          })
        )

        new_context
    end
  end
end

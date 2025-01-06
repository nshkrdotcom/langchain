defmodule LangChain.Middleware.Error do
  @moduledoc """
  Handles errors during API interactions.
  """
  @behaviour LangChain.Middleware.Behaviour
  alias LangChain.Error

  @impl LangChain.Middleware.Behaviour
  def handle_request(context, next) do
    context = Map.put(context, :error_middleware_invoked, true)
    try do
      next.(context)
    rescue
      e ->
        # Log the error
        Logger.error("LangChain Error: #{inspect(e)}")

        # Convert to a standardized error response (using LangChain.Error)
        %{
          error: %Error{
            type: :api_error, # or determine the type based on the exception
            message: "An error occurred during the API interaction.",
            details: %{exception: e}
          }
        }
    end
  end
end



defmodule LangChain.Middleware.ErrorMiddleware do
  @behaviour LangChain.Middleware.Behaviour
  alias LangChain.LangChainError

  def handle(context, next) do
    try do
      next.(context)
    rescue
      e in LangChainError -> {:error, e}
      e -> {:error, %LangChainError{message: Exception.message(e)}}
    end
  end
end

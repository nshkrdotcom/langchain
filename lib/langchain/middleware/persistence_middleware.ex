defmodule LangChain.Middleware.PersistenceMiddleware do
  @moduledoc """
  Middleware for persisting LangChain interactions.
  """
  @behaviour LangChain.Middleware.MiddlewareBehavior
  alias LangChain.Persistence

  def handle_request(context, next) do
    # Call the next middleware or the core logic
    context = next.(context)

    context
  end

  def handle_response(context, next) do
    # Call the next middleware or return the response
    context = next.(context)

    # Persist the interaction
    case Persistence.save_interaction(context) do
      {:ok, _} -> :ok
      {:error, reason} -> IO.warn("Failed to persist interaction: #{reason}")
    end

    context
  end
end



defmodule LangChain.Middleware.PersistenceMiddleware do
  @behaviour LangChain.Middleware.Behaviour
  alias LangChain.Persistence.Config

  def handle(context, next) do
    result = next.(context)

    if Config.enabled?() do
      case result do
        {:ok, response} ->
          Config.adapter().store_interaction(%{
            request: context,
            response: response,
            timestamp: DateTime.utc_now()
          })
          result
        error -> error
      end
    else
      result
    end
  end
end

defmodule LangChain.Middleware.Persistence do
  @moduledoc """
  Handles persistence of API interactions.
  """
  @behaviour LangChain.Middleware.Behaviour
  alias LangChain.Persistence

  @impl LangChain.Middleware.Behaviour
  def handle_request(context, next) do
    context = Map.put(context, :persistence_middleware_invoked, true)
    # Call the next middleware or handler
    response = next.(context)
    unless context.config[:persistence_disabled] do
        Task.start_link(fn ->
        Persistence.log_interaction(
            context.provider,
            context.model,
            context.request,
            response,
            Map.get(response, :error),
            context.opts
        )
        end)
    end

    # Return the response (middleware should not modify it unless specifically designed to)
    response
  end
end

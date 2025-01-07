require Logger
defmodule LangChain.Middleware.Logging do
  @moduledoc """
  Logs API requests and responses.
  """
  @behaviour LangChain.Middleware.Behaviour

  @impl LangChain.Middleware.Behaviour
  def handle_request(context, next) do
      context = Map.put(context, :logging_middleware_invoked, true)
      context = Map.put(context, :request_timestamp, :os.system_time(:millisecond))
      # Log the request
      Logger.info("LangChain Request: #{inspect(context.request)}")

      # Call the next middleware or handler
      response = next.(context)

      # Log the response
      Logger.info("LangChain Response: #{inspect(response)}")

      response
  end
end

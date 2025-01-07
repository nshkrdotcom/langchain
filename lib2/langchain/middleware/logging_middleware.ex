defmodule LangChain.Middleware.LoggingMiddleware do
  @moduledoc """
  Middleware for logging LangChain interactions.
  """
  @behaviour LangChain.Middleware.MiddlewareBehavior

  def handle_request(context, next) do
    # Log the request
    IO.inspect(context, label: "Request")

    # Call the next middleware or the core logic
    context = next.(context)

    context
  end

  def handle_response(context, next) do
    # Call the next middleware or return the response
    context = next.(context)

    # Log the response
    IO.inspect(context, label: "Response")

    context
  end
end



defmodule LangChain.Middleware.LoggingMiddleware do
  @behaviour LangChain.Middleware.Behaviour
  require Logger

  def handle(context, next) do
    start_time = System.monotonic_time()

    result = next.(context)

    end_time = System.monotonic_time()
    duration = System.convert_time_unit(end_time - start_time, :native, :millisecond)

    Logger.info("LLM call completed in #{duration}ms", context: context)

    result
  end
end

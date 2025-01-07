defmodule LangChain.Google.GenerativeModel do
  @moduledoc """
  Provides functions for interacting with Google's Gemini models.
  """
  alias LangChain.Google.Client
  alias LangChain.Error

  use LangChain.ChatModels.ChatModel,
    middleware: [
      LangChain.Middleware.ErrorMiddleware,
      LangChain.Middleware.LoggingMiddleware,
      LangChain.Middleware.PersistenceMiddleware
    ]

  def generate_content(prompt, opts \\ [], context \\ nil) do
    with {:ok, response} <- Client.generate_content(prompt, opts) do
      case Keyword.get(opts, :response_mime_type) do
        "application/json" -> {:ok, response}
        _ -> {:ok, response}
      end
    end
  end

  defp parse_response(body, status_code, _opts) do
    case status_code do
      200 -> {:ok, body}
      400 -> {:error, Error.exception(:api_error, "Bad Request", Jason.decode!(body))}
      401 -> {:error, Error.exception(:authentication_error, "Invalid API Key", %{})}
      429 -> {:error, Error.exception(:rate_limit_error, "Rate limit exceeded", %{})}
      _ -> {:error, Error.exception(:api_error, "Unknown API error", %{status_code: status_code, body: body})}
    end
  end

  defp apply_middleware(context, response) do
    context = Map.put(context, :response, response)
    context
    |> apply_logging_middleware()
    |> apply_persistence_middleware()
    |> apply_error_handling_middleware()
  end

  defp apply_logging_middleware(context) do
    IO.inspect(context, label: "LangChain.Google.GenerativeModel Context")
    context
  end

  defp apply_persistence_middleware(context) do
    if context.config[:persistence_enabled] do
      case LangChain.Persistence.save_interaction(context) do
        {:ok, _} -> context
        {:error, reason} ->
          IO.warn("Failed to persist interaction: #{reason}")
          context
      end
    else
      context
    end
  end

  defp apply_error_handling_middleware(context) do
    case context do
      %{error: %LangChain.Error{}} = error_context -> error_context
      _ -> context
    end
  end
end


#!/bin/bash

# Clean build artifacts
rm -rf _build

# Fix multiple module definitions by combining them into one file
cat > lib/langchain/persistence/persistence.ex << 'EOL'
defmodule LangChain.Persistence do
  @moduledoc """
  Manages the persistence of API interactions.
  """
  alias LangChain.Config
  alias LangChain.Persistence.{Logger, Config}

  def log_interaction(provider, model, request_data, response_data, error_data, opts) do
    Logger.log_interaction(provider, model, request_data, response_data, error_data, opts)
  end

  def child_spec(_) do
    %{
      id: Logger,
      start: {Logger, :start_link, [[]]}
    }
  end

  def setup() do
    backend_module = Config.get_persistence_backend()
    apply(backend_module, :setup, [])
  end

  def store_interaction(interaction_data) do
    if Config.enabled?() do
      Config.adapter().store_interaction(interaction_data)
    else
      {:ok, interaction_data}
    end
  end

  def retrieve_interaction(id) do
    if Config.enabled?() do
      Config.adapter().retrieve_interaction(id)
    else
      {:error, :persistence_disabled}
    end
  end

  def list_interactions(filters \\ %{}) do
    if Config.enabled?() do
      Config.adapter().list_interactions(filters)
    else
      {:error, :persistence_disabled}
    end
  end

  defdelegate store(interaction, opts \\ []), to: Config.adapter()
  defdelegate retrieve(id, opts \\ []), to: Config.adapter()
  defdelegate delete(id, opts \\ []), to: Config.adapter()
end
EOL

# Fix syntax error in generative_model.ex
cat > lib/provider_layer/providers/gemini/generative_model.ex << 'EOL'
defmodule LangChain.Google.GenerativeModel do
  @moduledoc """
  Provides functions for interacting with Google's Gemini models.
  """
  alias LangChain.Google.Client
  alias LangChain.Error

  def generate_content(prompt, opts \\ []) do
    with {:ok, response} <- Client.generate_content(prompt, opts) do
      case Keyword.get(opts, :response_mime_type) do
        "application/json" -> {:ok, response}
        _ -> {:ok, response}
      end
    end
  end

  use LangChain.ChatModels.ChatModel,
    middleware: [
      LangChain.Middleware.ErrorMiddleware,
      LangChain.Middleware.LoggingMiddleware,
      LangChain.Middleware.PersistenceMiddleware
    ]

  defp parse_response(body, status_code, opts) do
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
EOL

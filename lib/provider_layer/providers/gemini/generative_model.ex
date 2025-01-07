

# lib/langchain/google/generative_model.ex
defmodule LangChain.Google.GenerativeModel do
  @moduledoc """
  Provides functions for interacting with Google's Gemini models.
  """
  alias LangChain.Google.Client
  alias LangChain.Error

  @doc """
  Generates content using a Gemini model.

  ## Parameters

  - `prompt`: The input text prompt (string).
  - `opts`: A keyword list of options:
    - `:model`: The Gemini model to use (e.g., "gemini-1.5-flash-latest").
    - `:temperature`: Controls the randomness of the output (0.0 - 2.0).
    - `:top_p`: Nucleus sampling parameter.
    - `:top_k`: Top-k sampling parameter.
    - `:max_output_tokens`: Maximum number of tokens to generate.
    - `:response_mime_type`:  Specify "application/json" for JSON output.
    - `:response_schema`: An OpenAPI schema to enforce structured output.

  ## Returns

  - `{:ok, response}`: Where `response` is a map containing the generated text or JSON.
  - `{:error, %LangChain.Error{}}`: If there was an error during the API request.
  """
  def generate_content(_prompt, _opts \\ []) do
    with {:ok, response} <- Client.generate_content(prompt, opts) do
        case Keyword.get(opts, :response_mime_type) do
          "application/json" ->
            # If you need to do processing on the json beyond what is done in `parse_response`, you can do that here.
            {:ok, response}

          _ ->
            # If the mime type is not application/json then we assume it is text
            {:ok, response}
        end
    end
  end


    @moduledoc """
  Google's Generative Model implementation
  """
  use LangChain.ChatModels.ChatModel,
  middleware: [
    LangChain.Middleware.ErrorMiddleware,
    LangChain.Middleware.LoggingMiddleware,
    LangChain.Middleware.PersistenceMiddleware
  ]

# You can remove the `generate_content` function here since it is now handled by the middleware.



defp apply_middleware(context, response) do
  # This is a simplified example. In a real implementation, you would
  # likely have a configurable list of middleware functions.
  context = Map.put(context, :response, response)

  context
  |> apply_logging_middleware()
  |> apply_persistence_middleware()
  |> apply_error_handling_middleware()
end

defp apply_logging_middleware(context) do
  # Log the request and response
  IO.inspect(context, label: "LangChain.Google.GenerativeModel Context")
  context
end

defp apply_persistence_middleware(context) do
  # Persist the interaction if persistence is enabled
  if context.config[:persistence_enabled] do
    case LangChain.Persistence.save_interaction(context) do
      {:ok, _} ->
        context

      {:error, reason} ->
        # Log the error but don't fail the request
        IO.warn("Failed to persist interaction: #{reason}")
        context
    end
  else
    context
  end
end

defp apply_error_handling_middleware(context) do
  # Handle any errors that occurred during the API call or in other middleware
  case context do
    %{error: %LangChain.Error{}} = error_context ->
      error_context

    _ ->
      context
  end
end
end





























# lib/langchain/google/generative_model.ex
defmodule LangChain.Google.GenerativeModel do
  # ... other code ...
  alias LangChain.Error
  alias LangChain.HTTP

  def generate_content(_prompt, _opts \\ []) do
    # ... build request body as before, potentially refactored ...

    with {:ok, %HTTPoison.Response{status_code: status_code, body: body}} <-
           HTTP.post(url, headers, Jason.encode!(request_body)),
         {:ok, parsed_response} <- parse_response(body, status_code, opts) do
      {:ok, parsed_response}
    else
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, Error.exception(:http_error, "HTTP request failed", %{reason: reason})}

      {:error, error} ->
        {:error, error}  # Or handle API errors more specifically here
    end
  end

  defp parse_response(body, status_code, opts) do
      case status_code do
        200 ->
          # existing parsing logic
        400 ->
          {:error, Error.exception(:api_error, "Bad Request", Jason.decode!(body))}
        401 ->
          {:error, Error.exception(:authentication_error, "Invalid API Key", %{})}
        429 ->
          {:error, Error.exception(:rate_limit_error, "Rate limit exceeded", %{})}
        _ ->
          {:error, Error.exception(:api_error, "Unknown API error", %{status_code: status_code, body: body})}
      end
  end
end

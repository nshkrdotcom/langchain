defmodule LangChain.Providers.Gemini.Client do
  @moduledoc """
  Handles low-level interactions with the Google Gemini API.
  """
  alias LangChain.Config
  alias LangChain.Error

  @doc """
  Builds and sends a generateContent request to the Gemini API.

  ## Parameters

    - `prompt`: The input text prompt (string).
    - `opts`: A keyword list of options (see `LangChain.Google.GenerativeModel.generate_content` for details)

  ## Returns

    - `{:ok, response}`: Where `response` is a map containing the generated text or JSON.
    - `{:error, %LangChain.Error{}}`: If there was an error during the API request.
  """
  def generate_content(prompt, opts) do
    # 1. Build the request body
    request_body = build_request_body(prompt, opts)

    # 2. Make the API request
    model = Keyword.get(opts, :model, Application.get_env(:langchain, :default_model))
    url = "https://generativelanguage.googleapis.com/v1beta/#{model}:generateContent"
    api_key = Application.get_env(:langchain, :google_api_key)
    headers = [{"content-type", "application/json"}, {"x-goog-api-key", api_key}]

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           LangChain.HTTP.post(url, headers, Jason.encode!(request_body)) do
      # 3. Parse and return the response
      {:ok, parse_response(body, opts)}
    else
      {:error, error} -> {:error, error}
    end
  end

  defp build_request_body(prompt, opts) do
    body = %{
      contents: [
        %{
          role: "user",
          parts: [%{text: prompt}]
        }
      ]
    }

    body =
      if system_instruction = Keyword.get(opts, :system_instruction) do
        %{body | contents: [%{role: "system", parts: [%{text: system_instruction}]}] ++ body.contents}
      else
        body
      end

    body =
      if Keyword.has_key?(opts, :response_mime_type) do
        %{
          body
          | generationConfig: %{responseMimeType: Keyword.get(opts, :response_mime_type)}
        }
      else
        body
      end

    body =
      if schema = Keyword.get(opts, :response_schema) do
        %{
          body
          | generationConfig: %{
            responseMimeType: "application/json",
            responseSchema: schema
          }
        }
      else
        body
      end

    # Add other generation config options as needed
    body =
      Enum.reduce(
        [:temperature, :top_p, :top_k, :max_output_tokens],
        body,
        fn key, acc ->
          if value = Keyword.get(opts, key) do
            %{acc | generationConfig: Map.put(acc.generationConfig || %{}, key, value)}
          else
            acc
          end
        end
      )

    body
  end

  defp parse_response(body, status_code, opts) do
    case status_code do
      200 ->
        case Keyword.get(opts, :response_mime_type) do
          "application/json" ->
            # Handle JSON response (may need more sophisticated parsing for complex JSON structures)
            case Jason.decode(body) do
              {:ok, json_content} ->
                {:ok, %{text: body, json: json_content}}

              {:error, _reason} ->
                {:ok, %{text: body}}
            end

          _ ->
            # Assume it is a regular text response
            case Jason.decode(body) do
              {:ok, %{"candidates" => [%{"content" => %{"parts" => [%{"text" => text}]}}]}} ->
                {:ok, %{text: text}}

              {:error, _reason} ->
                {:ok, %{text: body}}
            end
        end

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





# lib/langchain/google/client.ex
defmodule LangChain.Google.Client do
  @moduledoc """
  Handles low-level interactions with the Google Gemini API.
  """
  alias LangChain.Config
  alias LangChain.Error

  @doc """
  Builds and sends a generateContent request to the Gemini API.

  ## Parameters

    - `prompt`: The input text prompt (string).
    - `opts`: A keyword list of options (see `LangChain.Google.GenerativeModel.generate_content` for details)

  ## Returns

    - `{:ok, response}`: Where `response` is a map containing the generated text or JSON.
    - `{:error, %LangChain.Error{}}`: If there was an error during the API request.
  """
  def generate_content(prompt, opts) do
    model = Config.get_model(:google, opts)
    api_key = Config.get_api_key(:google, opts)
    url = "https://generativelanguage.googleapis.com/v1beta/#{model}:generateContent"
    headers = [{"content-type", "application/json"}, {"x-goog-api-key", api_key}]

    with {:ok, body} <- build_request_body(prompt, opts),
         {:ok, %HTTPoison.Response{status_code: status_code, body: raw_body}} <-
           LangChain.HTTP.post(url, headers, Jason.encode!(body)) do
      parse_response(raw_body, status_code, opts)
    else
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, Error.exception(:http_error, "HTTP request failed", %{reason: reason})}
      {:error, error} ->
        {:error, error}
    end
  end

  # ... (moved and improved build_request_body here) ...
  defp build_request_body(prompt, opts) do
    # ... same implementation as before, potentially using some helper functions specific to the client
  end

  # ... (moved and improved parse_response here) ...
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


# lib/langchain/google/client.ex
defmodule LangChain.Google.Client do
  @moduledoc """
  Low level client for making api calls to the various google apis
  """
  @doc """
  Sends a generateContent request to a particular model
  """
  def generate_content(model, headers, body) do
      url = "https://generativelanguage.googleapis.com/v1beta/#{model}:generateContent"
      LangChain.HTTP.post(url, headers, body)
  end

  @doc """
  Streams content to a particular model. Note that streaming is not supported for all models.
  """
  def stream_generate_content(model, headers, body) do
      url = "https://generativelanguage.googleapis.com/v1beta/#{model}:streamGenerateContent"
      LangChain.HTTP.stream(url, headers, body)
  end

  @doc """
  Sends an embedContent request for a particualr model. Note that embeddings are not supported for all models.
  """
  def embed_content(model, headers, body) do
      url = "https://generativelanguage.googleapis.com/v1beta/#{model}:embedContent"
      LangChain.HTTP.post(url, headers, body)
  end

  @doc """
  Counts the number of tokens for a particular input.
  """
  def count_tokens(model, headers, body) do
      url = "https://generativelanguage.googleapis.com/v1beta/#{model}:countTokens"
      LangChain.HTTP.post(url, headers, body)
  end
end

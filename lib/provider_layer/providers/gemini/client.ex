defmodule LangChain.Google.Client do
  require Logger

  @gemini_api_url "https://generativelanguage.googleapis.com/v1"
  @model "models/gemini-pro"

  @spec generate_content(String.t()) :: {:ok, map()} | {:error, term()}
  def generate_content(prompt) do
    generate_content(prompt, [])
  end

  @spec generate_content(String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def generate_content(prompt, _opts) do
    api_key = Application.get_env(:langchain, :gemini_api_key)
    
    url = "#{@gemini_api_url}/#{@model}:generateContent"
    headers = [
      {"Content-Type", "application/json"},
      {"x-goog-api-key", api_key}
    ]
    
    body = %{
      "contents" => [
        %{
          "parts" => [
            %{
              "text" => prompt
            }
          ]
        }
      ]
    }

    case Req.post(url, json: body, headers: headers, receive_timeout: 30_000, pool_timeout: 30_000) do
      {:ok, %{status: 200, body: response}} ->
        {:ok, response}
      {:ok, %{status: status, body: error}} ->
        Logger.error("Gemini API error: #{status} - #{inspect(error)}")
        {:error, error}
      {:error, error} ->
        Logger.error("Request failed: #{inspect(error)}")
        {:error, error}
    end
  end
end


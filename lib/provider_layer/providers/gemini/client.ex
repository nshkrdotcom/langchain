defmodule LangChain.Gemini.Client do
  require Logger

  @gemini_api_url "https://generativelanguage.googleapis.com/v1"
  @model "models/gemini-pro"

  def generate_content(request) do
    make_request("generateContent", request)
  end

  def stream_generate_content(request) do
    make_request("streamGenerateContent", request, stream: true)
  end

  defp make_request(endpoint, request, opts \\ []) do
    url = "#{@gemini_api_url}/#{@model}:#{endpoint}"
    headers = build_headers()

    case Req.post(url, json: request, headers: headers, receive_timeout: 30_000) do
      {:ok, %{status: 200, body: response}} -> {:ok, response}
      {:ok, %{status: status, body: error}} ->
        Logger.error("Gemini API error: #{status} - #{inspect(error)}")
        {:error, error}
      {:error, error} ->
        Logger.error("Request failed: #{inspect(error)}")
        {:error, error}
    end
  end

  defp build_headers do
    api_key = Application.get_env(:langchain, :gemini_api_key)
    [
      {"Content-Type", "application/json"},
      {"x-goog-api-key", api_key}
    ]
  end
end

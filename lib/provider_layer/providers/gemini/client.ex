defmodule LangChain.Providers.Gemini.Client do
  @base_url "https://generativelanguage.googleapis.com/v1beta"

  def generate_content(prompt, opts \\ []) do
    model = Keyword.get(opts, :model, "gemini-pro")
    url = "#{@base_url}/models/#{model}:generateContent"

    headers = [
      {"Content-Type", "application/json"},
      {"x-goog-api-key", Application.get_env(:langchain, :gemini_api_key)}
    ]

    body = Jason.encode!(%{
      contents: [%{
        parts: [%{text: prompt}]
      }]
    })

    case HTTPoison.post(url, body, headers) do
      {:ok, %{status_code: 200, body: response}} ->
        {:ok, %{text: extract_text(Jason.decode!(response))}}
      {:error, error} ->
        {:error, error}
    end
  end

  defp extract_text(%{"candidates" => [%{"content" => %{"parts" => [%{"text" => text}]}} | _]}) do
    text
  end
end

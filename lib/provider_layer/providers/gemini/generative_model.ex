
defmodule LangChain.Provider.Gemini.GenerativeModel do
  alias LangChain.Provider.Gemini.Client

  @spec generate_content(String.t(), keyword()) :: {:ok, map()} | {:error, String.t()}
  def generate_content(prompt, opts \\ [])
  def generate_content(prompt, opts) when is_binary(prompt) do
    request = build_request(prompt, opts)
    Client.generate_content(request)
  end
  def generate_content(_prompt, _opts), do: {:error, "Invalid prompt"}

  @spec stream_generate_content(String.t(), keyword()) :: {:ok, map()} | {:error, String.t()}
  def stream_generate_content(prompt, opts \\ []) when is_binary(prompt) do
    request = build_request(prompt, opts)
    Client.stream_generate_content(request)
  end

  defp build_request(prompt, opts) do
    generation_config = case opts do
      [] -> %{}
      opts ->
        if temp = Keyword.get(opts, :temperature) do
          %{"temperature" => temp}
        else
          %{}
        end
    end

    schema = Keyword.get(opts, :structured_output)
    contents = if schema do
      [%{
        "parts" => [%{
          "text" => prompt <> "\n\nProvide response as valid JSON without code blocks or backticks. Schema:\n#{inspect(schema)}"
        }]
      }]
    else
      [%{"parts" => [%{"text" => prompt}]}]
    end

    request = %{"contents" => contents}
    if map_size(generation_config) > 0 do
      Map.put(request, "generationConfig", generation_config)
    else
      request
    end
  end
end

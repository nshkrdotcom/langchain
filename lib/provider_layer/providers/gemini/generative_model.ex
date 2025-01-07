
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
    base_request = %{
      "contents" => [%{"parts" => [%{"text" => prompt}]}]
    }

    {tools, generation_config} = case opts do
      [] -> {nil, %{}}
      opts ->
        tools = Keyword.get(opts, :tools)
        config = if temp = Keyword.get(opts, :temperature) do
          %{"temperature" => temp}
        else
          %{}
        end
        {tools, config}
    end

    base_request
    |> maybe_add_tools(tools)
    |> maybe_add_config(generation_config)
    |> maybe_add_structured_output(Keyword.get(opts, :structured_output))
  end

  defp maybe_add_tools(request, nil), do: request
  defp maybe_add_tools(request, tools), do: Map.put(request, "tools", tools)

  defp maybe_add_config(request, config) when map_size(config) == 0, do: request
  defp maybe_add_config(request, config), do: Map.put(request, "generationConfig", config)

  defp maybe_add_structured_output(request, nil), do: request
  defp maybe_add_structured_output(request, schema), do: Map.put(request, "tools", [%{"function_declarations" => [schema]}])
end

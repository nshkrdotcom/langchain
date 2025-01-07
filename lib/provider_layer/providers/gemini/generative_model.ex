defmodule LangChain.Provider.Gemini.GenerativeModel do
  alias LangChain.Provider.Gemini.Client

  @spec generate_content(String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def generate_content(prompt, opts \\ []) when is_binary(prompt) do
    request = build_request(prompt, opts)
    Client.generate_content(request)
  end

  @spec stream_generate_content(String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def stream_generate_content(prompt, opts \\ []) when is_binary(prompt) do
    request = build_request(prompt, opts)
    Client.stream_generate_content(request)
  end

  def generate_content(prompt, _opts) when not is_binary(prompt), do: {:error, "Invalid prompt"}

  defp build_request(prompt, opts) do
    base_request = %{
      "contents" => [%{"parts" => [%{"text" => prompt}]}]
    }

    {tools, generation_config} = case opts do
      [] -> {nil, %{}}
      opts ->
        tools = Keyword.get(opts, :tools)
        config = Keyword.get(opts, :temperature) && %{
          "temperature" => Keyword.get(opts, :temperature, 0.1),
          "candidateCount" => Keyword.get(opts, :candidate_count, 1)
        } || %{}
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

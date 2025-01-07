defmodule LangChain.Gemini.GenerativeModel do
  @moduledoc """
  Provides functions for interacting with Gemini's Gemini models.
  """
  alias LangChain.Gemini.Client

  @spec generate_content(String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def generate_content(prompt, opts \\ [])  
  def generate_content(prompt, _opts) when not is_binary(prompt), do: {:error, "Invalid prompt"}
  def generate_content(prompt, opts) when is_binary(prompt) do

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

    request = %{"contents" => [%{"parts" => [%{"text" => prompt}]}]}
    |> maybe_add_tools(tools)
    |> maybe_add_config(generation_config)

    Client.generate_content(request)
  end



  defp maybe_add_tools(request, nil), do: request
  defp maybe_add_tools(request, tools), do: Map.put(request, "tools", tools)

  defp maybe_add_config(request, config) when map_size(config) == 0, do: request
  defp maybe_add_config(request, config), do: Map.put(request, "generationConfig", config)






end


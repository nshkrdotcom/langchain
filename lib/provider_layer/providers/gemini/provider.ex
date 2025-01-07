defmodule LangChain.Provider.Gemini.Provider do
  require Logger
  alias LangChain.Google.GenerativeModel

  def generate_content(prompt, opts \\ []) do
    generation_config = case Keyword.get(opts, :structured_output) do
      nil -> []
      schema -> [
        generationConfig: %{
          temperature: 0.1,
          candidate_count: 1
        },
        tools: [%{
          functionDeclarations: [%{
            name: "process_structured_output",
            description: "Process structured output according to schema",
            parameters: %{
              type: "object",
              properties: convert_schema_format(schema)
            }
          }]
        }]
      ]
    end

    case GenerativeModel.generate_content(prompt, generation_config) do
      {:ok, response} -> 
        #Logger.debug("Received Gemini response: #{inspect(response, pretty: true)}")
        case get_in(response, ["candidates", Access.at(0), "content", "parts", Access.at(0), "text"]) do
          nil -> 
            Logger.error("Failed to extract text from response structure: #{inspect(response, pretty: true)}")
            {:error, "Invalid response format"}
          text -> 
            case Keyword.get(opts, :structured_output) do
              nil -> {:ok, text}
              _schema -> Jason.decode(text)
            end
        end
      error -> 
        Logger.error("Gemini API error: #{inspect(error, pretty: true)}")
        error
    end
  end

  defp convert_schema_format(schema) do
    case schema do
      %{type: type} = s when is_map(s) ->
        %{
          "type" => String.upcase("#{type}"),
          "properties" => convert_properties(Map.get(s, :properties, %{})),
          "items" => convert_schema_format(Map.get(s, :items, %{}))
        }
      _ -> %{}
    end
  end

  defp convert_properties(properties) when is_map(properties) do
    for {key, value} <- properties, into: %{} do
      {key, %{"type" => String.upcase("#{value.type}")}}
    end
  end
  defp convert_properties(_), do: %{}
end

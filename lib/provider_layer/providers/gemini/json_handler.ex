
defmodule LangChain.Provider.Gemini.JsonHandler do
  require Logger

  def clean_json_text(text) when is_binary(text) do
    text
    |> String.trim()
    |> String.replace(~r/```(json)?\s*/, "")
    |> String.replace("```", "")
    |> String.trim()
  end

  def decode_and_validate(text, schema \\ nil) do
    case Jason.decode(clean_json_text(text)) do
      {:ok, decoded} when is_map(decoded) ->
        if validate_json_structure(decoded, schema) do
          {:ok, decoded}
        else
          {:error, %{status: 400, body: "Invalid JSON structure"}}
        end
      _ ->
        {:error, %{status: 400, body: "Invalid JSON response"}}
    end
  end

  defp validate_json_structure(_decoded, nil), do: true
  defp validate_json_structure(%{"type" => "object"}, _schema), do: false
  defp validate_json_structure(decoded, _schema) when map_size(decoded) == 0, do: false
  defp validate_json_structure(decoded, _schema) when is_map(decoded), do: true
  defp validate_json_structure(_decoded, _schema), do: false

  def default_schema do
    """
    {
      "type": "object",
      "properties": {
        "languages": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "name": {"type": "string"},
              "paradigm": {"type": "string"},
              "year_created": {"type": "number"}
            }
          }
        }
      }
    }
    """
  end
end

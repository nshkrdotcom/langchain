
defmodule LangChain.Provider.Gemini.JsonHandler do
  require Logger

  def clean_json_text(text) when is_binary(text) do
    text
    |> String.trim()
    |> String.replace(~r/```(json)?\s*/, "")
    |> String.replace("```", "")
    |> String.trim()
  end

  def decode_and_validate(text, _schema \\ nil) do
    cleaned_text = clean_json_text(text)
    Logger.debug("Attempting to parse JSON response: #{inspect(cleaned_text)}")

    case Jason.decode(cleaned_text) do
      {:ok, decoded} when is_map(decoded) ->
        Logger.debug("Parsed JSON: #{inspect(decoded)}")

        if validate_json_structure(decoded) do
          {:ok, decoded}
        else
          Logger.debug("Invalid structure detected: #{inspect(decoded)}")
          {:error, %{status: 400, body: "Invalid JSON structure"}}
        end
      _ ->
        {:error, %{status: 400, body: "Invalid JSON response"}}
    end
  end

  defp validate_json_structure(%{"" => ""}) do
    false
  end

  defp validate_json_structure(%{"type" => "object", "properties" => _}) do
    false
  end

  defp validate_json_structure(decoded) when map_size(decoded) == 0 do
    false
  end

  defp validate_json_structure(%{"analysis" => analysis}) when is_map(analysis) do
    true
  end

  defp validate_json_structure(decoded) when is_map(decoded) do
    Logger.debug("Validating map structure: #{inspect(decoded)}")
    Logger.debug("Number of keys: #{length(Map.keys(decoded))}")
    has_keys = Map.keys(decoded) |> length() > 0
    Logger.debug("Has keys validation result: #{has_keys}")
    has_keys
  end

  defp validate_json_structure(_) do
    false
  end

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

defmodule LangChain.ChatModels.Validation.SchemaValidator do
  @moduledoc """
  Handles JSON schema validation for model responses.
  """
  
  def validate(json, schema) do
    case validate_type(json, schema["type"]) do
      :ok -> validate_properties(json, schema["properties"])
      error -> error
    end
  end

  defp validate_type(value, "object") when is_map(value), do: :ok
  defp validate_type(value, "array") when is_list(value), do: :ok
  defp validate_type(value, "string") when is_binary(value), do: :ok
  defp validate_type(value, "number") when is_number(value), do: :ok
  defp validate_type(value, "boolean") when is_boolean(value), do: :ok
  defp validate_type(_value, type), do: {:error, "Invalid type: #{type}"}

  defp validate_properties(json, properties) when is_map(properties) do
    properties
    |> Enum.reduce_while(:ok, fn {key, schema}, _acc ->
      case validate(Map.get(json, key), schema) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end
  defp validate_properties(_json, _schema), do: :ok
end

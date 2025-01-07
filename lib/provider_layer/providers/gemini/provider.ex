defmodule LangChain.Provider.Gemini do
  alias LangChain.Provider.Error
  require Logger
  alias LangChain.Google.GenerativeModel

  def generate_content(prompt, opts \\ []) do
    case make_request(prompt, opts) do
      {:ok, response} ->
        {:ok, process_response(response, opts)}
      {:error, reason} ->
        {:error, Error.from_response(reason, :gemini)}
    end
  end

  defp make_request(prompt, _opts) when not is_binary(prompt), do: {:error, "Invalid prompt"}
  defp make_request("", opts) do
    case Keyword.get(opts, :structured_output) do
      nil -> {:error, %{status: 400, body: "Empty prompt"}}
      _ -> {:ok, %{}}
    end
  end
  defp make_request(prompt, opts) when is_binary(prompt) do
    {final_prompt, config} = case Keyword.get(opts, :structured_output) do
      nil -> {prompt, [temperature: 0.1, candidate_count: 1]}
      schema ->
        schema_str = case schema do
          %{type: :object, properties: props} ->
            Jason.encode!(%{type: "object", properties: props})
          _ -> LangChain.Provider.Gemini.JsonHandler.default_schema()
        end
        {
          """
          Return a JSON response matching this schema: #{schema_str}

          Important: Your response must be valid JSON only, no other text.
          Do not include markdown formatting or code blocks.

          Prompt: #{prompt}
          """,
          [temperature: 0.1, candidate_count: 1]
        }
    end

    GenerativeModel.generate_content(final_prompt, config)
  end

  defp process_response(%{} = response, opts) when map_size(response) == 0 do
    case Keyword.get(opts, :structured_output) do
      nil -> {:error, "Empty response"}
      _ -> %{}
    end
  end
  defp process_response(response, opts) do
    case get_in(response, ["candidates", Access.at(0), "content", "parts", Access.at(0), "text"]) do
      nil ->
        Logger.error("Failed to extract text from response structure: #{inspect(response, pretty: true)}")
        {:error, "Invalid response format"}
      text ->
        case Keyword.get(opts, :structured_output) do
          nil -> text
          schema ->
            case LangChain.Provider.Gemini.JsonHandler.decode_and_validate(text, schema) do
              {:error, %{status: _, body: _} = reason} -> {:error, reason}
              {:ok, {:error, reason}} -> {:error, reason}
              {:ok, decoded} -> decoded
            end
        end
    end
  end
end

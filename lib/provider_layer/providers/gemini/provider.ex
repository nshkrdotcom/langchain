defmodule LangChain.Provider.Gemini.Provider do
  require Logger
  alias LangChain.Google.GenerativeModel

  def generate_content(prompt, opts \\ [])
  def generate_content(prompt, _opts) when not is_binary(prompt), do: {:error, "Invalid prompt"}
  def generate_content("", opts) do
    case Keyword.get(opts, :structured_output) do
      nil -> {:error, "Empty prompt"}
      _ -> {:ok, %{}}
    end
  end
  def generate_content(prompt, opts) when is_binary(prompt) do
    {final_prompt, config} = case Keyword.get(opts, :structured_output) do
      nil -> {prompt, [temperature: 0.1, candidate_count: 1]}
      _schema ->
        schema_str = case opts[:structured_output] do
        %{type: :object, properties: props} ->
          Jason.encode!(%{type: "object", properties: props})
        _ ->
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

    case GenerativeModel.generate_content(final_prompt, config) do
      {:ok, response} ->
        case get_in(response, ["candidates", Access.at(0), "content", "parts", Access.at(0), "text"]) do
          nil ->
            Logger.error("Failed to extract text from response structure: #{inspect(response, pretty: true)}")
            {:error, "Invalid response format"}
          text ->
            case Keyword.get(opts, :structured_output) do
              nil -> {:ok, text}
              _schema ->
                # First validate if the response looks like JSON
                if String.trim(text) =~ ~r/^[{\[].*[}\]]$/ do
                  case Jason.decode(text) do
                    {:ok, decoded} when is_map(decoded) -> {:ok, decoded}
                    _ -> {:error, "Invalid JSON response"}
                  end
                else
                  {:error, "Invalid JSON response"}
                end
            end
        end
      error ->
        Logger.error("Gemini API error: #{inspect(error, pretty: true)}")
        error
    end
  end
end

defmodule LangChain.Provider.Gemini.Provider do
  require Logger
  alias LangChain.Google.GenerativeModel

  def generate_content(prompt, opts \\ []) do
    {final_prompt, config} = case Keyword.get(opts, :structured_output) do
      nil -> {prompt, [temperature: 0.1, candidate_count: 1]}
      _schema ->
        schema_str = """
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
              _schema -> Jason.decode(text)
            end
        end
      error -> 
        Logger.error("Gemini API error: #{inspect(error, pretty: true)}")
        error
    end
  end
end

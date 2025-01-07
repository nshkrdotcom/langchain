defmodule LangChain.Provider.Gemini.Provider do
  require Logger
  alias LangChain.Google.GenerativeModel

  def generate_content(prompt, opts \\ []) do
    case GenerativeModel.generate_content(prompt, opts) do
      {:ok, response} -> 
        #Logger.debug("Received Gemini response: #{inspect(response, pretty: true)}")
        case get_in(response, ["candidates", Access.at(0), "content", "parts", Access.at(0), "text"]) do
          nil -> 
            Logger.error("Failed to extract text from response structure: #{inspect(response, pretty: true)}")
            {:error, "Invalid response format"}
          text -> {:ok, text}
        end
      error -> 
        Logger.error("Gemini API error: #{inspect(error, pretty: true)}")
        error
    end
  end
end

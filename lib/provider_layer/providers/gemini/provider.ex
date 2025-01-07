defmodule LangChain.Provider.Gemini.Provider do
  alias LangChain.Google.GenerativeModel

  def generate_content(prompt, opts \\ []) do
    case GenerativeModel.generate_content(prompt, opts) do
      {:ok, response} -> 
        case get_in(response, ["candidates", Access.at(0), "content", "parts", Access.at(0), "text"]) do
          nil -> {:error, "Invalid response format"}
          text -> {:ok, text}
        end
      error -> error
    end
  end
end

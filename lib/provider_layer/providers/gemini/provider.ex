defmodule LangChain.ProviderLayer.Providers.Gemini.Provider do
  @behaviour LangChain.Provider
  alias LangChain.Google.GenerativeModel

  @impl LangChain.Provider
  def generate_content(prompt, opts \\ []) do
    case GenerativeModel.generate_content(prompt, opts) do
      {:ok, response} -> {:ok, response.text}
      error -> error
    end
  end
end

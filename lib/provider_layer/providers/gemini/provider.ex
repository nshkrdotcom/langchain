defmodule LangChain.ProviderLayer.Providers.Gemini.Provider do
  @behaviour LangChain.Provider.Behavior  # Fixed behavior path
  alias LangChain.Google.GenerativeModel

  @spec generate(String.t()) :: {:ok, String.t()} | {:error, term()}
  def generate(nil), do: {:error, "Prompt cannot be nil"}
  def generate(prompt) when is_binary(prompt) do
    case GenerativeModel.generate_content(prompt) do
      {:ok, response} -> {:ok, response.text}
      error -> error
    end
  end
end

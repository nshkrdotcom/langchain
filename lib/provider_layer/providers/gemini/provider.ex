defmodule LangChain.Provider.Gemini do
  alias LangChain.Provider.Gemini.Client # Assuming this module will be created separately to wrap LangChain.Google.Client
  alias LangChain.Provider.Gemini.GenerativeModel

  @spec generate_content(String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def generate_content(prompt, opts \\ []) do
    GenerativeModel.generate_content(prompt, opts)
  end

  def stream_generate_content(prompt, opts \\ []) do
    GenerativeModel.stream_generate_content(prompt, opts)
  end
end

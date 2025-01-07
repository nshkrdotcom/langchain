# lib/langchain/google.ex (Gemini provider module)
defmodule LangChain.Gemini do
  @moduledoc "Implementation of the LangChain.Provider behaviour for Gemini's AI models"
  @behaviour LangChain.Provider
  alias LangChain.Gemini.GenerativeModel # etc...

  def generate_content(prompt, opts) do
    GenerativeModel.generate_content(prompt, opts)
  end

  def stream_generate_content(_prompt, _opts) do
    # Delegate to LangChain.Gemini.GenerativeModel.stream_generate_content
  end

  # ... other functions implementing the LangChain.Provider behaviour ...
end

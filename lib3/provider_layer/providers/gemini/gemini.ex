# lib/langchain/google.ex (Google provider module)
defmodule LangChain.Google do
  @moduledoc "Implementation of the LangChain.Provider behaviour for Google's AI models"
  @behaviour LangChain.Provider
  alias LangChain.Google.GenerativeModel # etc...

  def generate_content(prompt, opts) do
    GenerativeModel.generate_content(prompt, opts)
  end

  def stream_generate_content(prompt, opts) do
    # Delegate to LangChain.Google.GenerativeModel.stream_generate_content
  end

  # ... other functions implementing the LangChain.Provider behaviour ...
end

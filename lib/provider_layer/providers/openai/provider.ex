defmodule LangChain.Provider.OpenAI do
  @behaviour LangChain.Provider.Behavior
  
  def generate_content(_prompt, _opts \\ []) do
    # Implementation
  end
  
  def stream_content(_prompt, _opts \\ []) do
    # Implementation
  end
  
  def generate_embeddings(_text, _opts \\ []) do
    # Implementation
  end
end

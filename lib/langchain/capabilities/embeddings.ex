defmodule LangChain.Capabilities.Embeddings do
  alias LangChain.Config

  def embed_text(text, opts \\ []) do
    provider = Config.get_provider(opts)
    provider.generate_embeddings(text, opts)
  end
end

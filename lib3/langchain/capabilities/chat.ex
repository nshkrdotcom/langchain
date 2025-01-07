defmodule LangChain.Capabilities.Chat do
  def chat(messages, opts \\ []) do
    provider = LangChain.Config.get_provider(opts)
    provider.generate_content(messages, opts)
  end
end

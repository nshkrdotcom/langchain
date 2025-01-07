defmodule LangChain.Capabilities.Completion do
  alias LangChain.Config

  def complete(prompt, opts \\ []) do
    provider = Config.get_provider(opts)
    provider.generate_content(prompt, opts)
  end
end

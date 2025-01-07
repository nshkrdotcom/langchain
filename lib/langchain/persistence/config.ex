defmodule LangChain.Persistence.Config do
  def enabled?, do: true
  
  def adapter do
    Application.get_env(:langchain, :persistence_adapter, LangChain.Persistence.PostgresAdapter)
  end
end

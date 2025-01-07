defmodule LangChain.Persistence.Config do
  def get_persistence_backend do
    Application.get_env(:langchain, :persistence_adapter, LangChain.Persistence.PostgresAdapter)
  end
  
  def enabled?, do: true
  
  def adapter do
    Application.get_env(:langchain, :persistence_adapter, LangChain.Persistence.PostgresAdapter)
  end
end

defmodule LangChain.Persistence.Config do
  @moduledoc """
  Configuration for persistence layer
  """
  
  def get_persistence_backend do
    Application.get_env(:langchain, :persistence_backend, LangChain.Persistence.Memory)
  end
  
  def adapter do
    Application.get_env(:langchain, :persistence_adapter, LangChain.Persistence.PostgresAdapter)
  end
end

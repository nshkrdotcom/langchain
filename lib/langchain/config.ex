defmodule LangChain.Config do
  @moduledoc """
  Configuration for LangChain
  """
  
  def get_provider(opts \\ []) do
    Keyword.get(opts, :provider, Application.get_env(:langchain, :default_provider))
  end
  
  def get_persistence_backend do
    Application.get_env(:langchain, :persistence_backend, LangChain.Persistence.Memory)
  end
end

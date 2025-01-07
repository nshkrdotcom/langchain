defmodule LangChain.Persistence.Config do
  def enabled?, do: Application.get_env(:langchain, :persistence_enabled, false)

  def adapter, do: Application.get_env(:langchain, :persistence_adapter, LangChain.Persistence.PostgresAdapter)

  def options, do: Application.get_env(:langchain, :persistence_options, [])
end


defmodule LangChain.Config do
  def load do
    Application.load(:langchain)
        _config = Application.get_env(:langchain, :persistence)
  end
end

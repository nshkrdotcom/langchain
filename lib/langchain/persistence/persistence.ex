defmodule LangChain.Persistence do
  @moduledoc """
  Manages the persistence of API interactions.
  """
  alias LangChain.Config
  alias LangChain.Persistence.Logger

  def log_interaction(provider, model, request_data, response_data, error_data, opts) do
      Logger.log_interaction(provider, model, request_data, response_data, error_data, opts)
  end

  def child_spec(_) do
    %{
      id: Logger,
      start: {Logger, :start_link, [[]]}
    }
  end

  def setup() do
    # Ensure the database and any required tables exist
    backend_module = Config.get_persistence_backend()
    apply(backend_module, :setup, [])
  end
end


defmodule LangChain.Persistence do
  alias LangChain.Persistence.Config

  def store_interaction(interaction_data) do
    if Config.enabled?() do
      Config.adapter().store_interaction(interaction_data)
    else
      {:ok, interaction_data}
    end
  end

  def retrieve_interaction(id) do
    if Config.enabled?() do
      Config.adapter().retrieve_interaction(id)
    else
      {:error, :persistence_disabled}
    end
  end

  def list_interactions(filters \\ %{}) do
    if Config.enabled?() do
      Config.adapter().list_interactions(filters)
    else
      {:error, :persistence_disabled}
    end
  end
end

#To use this in your config:
defmodule LangChain.Persistence do
  @moduledoc """
  Provides a generic interface for persistent storage of PI interactions.
  """

  defdelegate store(interaction, opts \\ []), to: :__MODULE__.adapter()
  defdelegate retrieve(id, opts \\ []), to: :__MODULE__.adapter()
  defdelegate delete(id, opts \\ []), to: :__MODULE__.adapter()

  defp adapter do
    Application.get_env(:langchain, :persistence_adapter)
  end
end

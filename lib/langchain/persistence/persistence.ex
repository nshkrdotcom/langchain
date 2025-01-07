defmodule LangChain.Persistence do
  @moduledoc """
  Manages the persistence of API interactions.
  """
  alias LangChain.Config
  alias LangChain.Persistence.{Logger, Config}

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
    backend_module = Config.get_persistence_backend()
    apply(backend_module, :setup, [])
  end

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

  defdelegate store(interaction, opts \\ []), to: Config.adapter()
  defdelegate retrieve(id, opts \\ []), to: Config.adapter()
  defdelegate delete(id, opts \\ []), to: Config.adapter()
end

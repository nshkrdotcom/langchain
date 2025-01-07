require Logger
defmodule LangChain.Persistence.Logger do
  @moduledoc """
  Asynchronously logs API interactions to the configured persistence backend.
  """
  use GenServer
  alias LangChain.Config

  def start_link(opts) do
      GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
      {:ok, %{}}
  end

  @doc """
  Logs an interaction to the persistence backend.
  """
  def log_interaction(provider, model, request_data, response_data, error_data, opts) do
      GenServer.cast(__MODULE__, {:log_interaction, self(), provider, model, request_data, response_data, error_data, opts})
  end

  @impl true
  def handle_cast({:log_interaction, _pid, provider, model, request_data, response_data, error_data, opts}, state) do
      backend_module = Config.get_persistence_backend()

      case apply(backend_module, :store_interaction, [
              provider,
              model,
              request_data,
              response_data,
              error_data,
              opts
          ]) do
      :ok ->
          # Maybe send a message back to the caller indicating success if needed
          :ok
      {:error, reason} ->
          # Handle the error (log it, potentially retry, etc.)
          Logger.error("Failed to store interaction: #{reason}")
          # You might want to send a message back to the caller indicating failure
          :ok
      end

      {:noreply, state}
  end
end

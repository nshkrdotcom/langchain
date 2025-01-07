defmodule LangChain.Persistence.Postgres do
  @moduledoc """
  PostgreSQL backend adapter for LangChain persistence.
  """
  use Ecto.Schema
  import Ecto.Query, warn: false
  alias LangChain.Persistence.Backend
  alias LangChain.Repo

  @behaviour Backend

  @impl Backend
  def setup() do
    {:ok, _} = Ecto.Migrator.with_repo(Repo, &Ecto.Migrator.run(&1, :up, all: true))
  end

  @impl Backend
  def store_interaction(provider, model, request_data, response_data, error_data, opts) do
    interaction_data = %{
      provider: provider,
      model: model,
      prompt: request_data["prompt"],
      response: response_data,
      metadata: %{
        error: error_data,
        request: request_data,
        options: opts
      },
      timestamp: NaiveDateTime.utc_now()
    }

    with {:ok, interaction} <- create_interaction(interaction_data) do
      {:ok, interaction}
    end
  end

  defp create_interaction(attrs) do
    %LangChain.Interaction{}
    |> Map.merge(attrs)
    |> Repo.insert()
  end
end

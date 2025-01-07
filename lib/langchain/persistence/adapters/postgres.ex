# lib/langchain/persistence/postgres.ex
defmodule LangChain.Persistence.Postgres do
  @moduledoc """
  PostgreSQL backend adapter for LangChain persistence.
  """
  use Ecto.Schema
  import Ecto.Query, warn: false
  alias LangChain.Config
  alias LangChain.Persistence.Backend
  alias LangChain.Repo

  @behaviour Backend

  @impl Backend
  def setup() do
    # Use Ecto to create the database and tables if they don't exist
    # You might need to adapt this based on your Ecto setup
    {:ok, _} = Ecto.Migrator.with_repo(Repo, &Ecto.Migrator.run(&1, :up, all: true))
  end

  @impl Backend
  def store_interaction(provider, model, request_data, response_data, error_data, opts) do
    interaction = %LangChain.Interaction{
      provider: provider,
      model: model,
      request_timestamp: NaiveDateTime.utc_now(),
      request_data: request_data,
      response_data: response_data,
      error_data: error_data,
      opts: opts
    }

    Repo.insert(interaction)
  end
end

defmodule LangChain.Persistence.PostgresAdapter do
  @behaviour LangChain.Persistence.StorageBehavior

  alias LangChain.Repo
  alias LangChain.Persistence.Schema.Interaction

  @impl true
  def store_interaction(interaction_data) do
    %Interaction{}
    |> Interaction.changeset(interaction_data)
    |> Repo.insert()
  end

  @impl true
  def retrieve_interaction(id) do
    case Repo.get(Interaction, id) do
      nil -> {:error, :not_found}
      interaction -> {:ok, interaction}
    end
  end

  @impl true
  def list_interactions(filters) do
    query = from i in Interaction,
            where: ^build_filters(filters)
    {:ok, Repo.all(query)}
  end

  @impl true
  def delete_interaction(id) do
    case retrieve_interaction(id) do
      {:ok, interaction} -> Repo.delete(interaction)
      error -> error
    end
  end
end

#To use this in your config:
defmodule LangChain.Persistence.PostgresAdapter do
  @moduledoc """
  Implements the Persistence behavior for PostgreSQL.
  """

  use LangChain.Persistence

  def store(interaction, opts) do
    #Implementation to store in Postgres
    {:ok, :stored}
  end

  def retrieve(id, opts) do
    #Implementation to retrieve from Postgres
    {:ok, %{id: id, interaction: "interaction"}}
  end

  def delete(id, opts) do
    #Implementation to delete from Postgres
    {:ok, :deleted}
  end
end

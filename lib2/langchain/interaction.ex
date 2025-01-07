defmodule LangChain.Interaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "interactions" do
    field :provider, :string
    field :model, :string
    field :request_timestamp, :utc_datetime
    field :response_timestamp, :utc_datetime
    field :request_data, :map
    field :response_data, :map
    field :error_data, :map
    field :opts, :map

    timestamps()
  end

  @doc false
  def changeset(interaction, attrs) do
    interaction
    |> cast(attrs, [:provider, :model, :request_timestamp, :response_timestamp, :request_data, :response_data, :error_data, :opts])
    |> validate_required([:provider, :model, :request_timestamp, :request_data])
  end
end

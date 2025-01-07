
defmodule LangChain.Persistence.Schema.Interaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "interactions" do
    field :model, :string
    field :prompt, :string
    field :response, :map
    field :metadata, :map
    field :token_usage, :map

    timestamps()
  end

  def changeset(interaction, attrs) do
    interaction
    |> cast(attrs, [:model, :prompt, :response, :metadata, :token_usage])
    |> validate_required([:model, :prompt, :response])
  end
end

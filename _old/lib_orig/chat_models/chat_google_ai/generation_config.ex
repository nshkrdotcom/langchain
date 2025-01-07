defmodule LangChain.ChatModels.ChatGoogleAI.GenerationConfig do
  @moduledoc """
  Represents the generation configuration for interacting with the Google AI API.

  This module defines a struct that mirrors the `GenerationConfig` object in the
  Gemini API documentation, allowing for fine-grained control over the model's
  generation process and output format.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias LangChain.LangChainError

  @primary_key false
  embedded_schema do
    field :stop_sequences, {:array, :string}
    field :response_mime_type, :string, default: "text/plain"
    field :response_schema, :map
    field :candidate_count, :integer, default: 1
    field :max_output_tokens, :integer
    field :temperature, :float, default: 0.9
    field :top_p, :float, default: 1.0
    field :top_k, :integer, default: 1
    field :presence_penalty, :float
    field :frequency_penalty, :float
    field :response_logprobs, :boolean, default: false
    field :logprobs, :integer
  end

  @type t :: %__MODULE__{}

  @create_fields [
    :stop_sequences,
    :response_mime_type,
    :response_schema,
    :candidate_count,
    :max_output_tokens,
    :temperature,
    :top_p,
    :top_k,
    :presence_penalty,
    :frequency_penalty,
    :response_logprobs,
    :logprobs
  ]

  @doc """
  Creates a new `GenerationConfig` struct.
  """
  @spec new(attrs :: map()) :: {:ok, t} | {:error, Ecto.Changeset.t()}
  def new(attrs \\ %{}) do
    %__MODULE__{}
    |> __MODULE__.changeset(attrs)
    |> apply_action(:insert)
  end

  @doc """
  Creates a new GenerationConfig struct and raises if invalid.
  """
  @spec new!(attrs :: map()) :: t() | no_return()
  def new!(attrs \\ %{}) do
    case new(attrs) do
      {:ok, config} -> config
      {:error, changeset} -> raise LangChainError, changeset
    end
  end

  @doc """
  Creates a changeset for the `GenerationConfig` struct.
  """
  @spec changeset(t(), map()) :: Ecto.Changeset.t()
#  def changeset(struct, attrs \\ %{}) do
#    struct
#    |> cast(attrs, @create_fields)
#    |> validate_required([:response_mime_type])
#    |> validate_inclusion(:response_mime_type, [
#      "text/plain",
#      "application/json"
#    ])
#    |> validate_number(:candidate_count, greater_than_or_equal_to: 1)
#    |> validate_number(:temperature, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 2.0)
#    |> validate_number(:top_p, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0)
#    |> validate_number(:presence_penalty, greater_than_or_equal_to: -2.0, less_than_or_equal_to: 2.0)
#    |> validate_number(:frequency_penalty, greater_than_or_equal_to: -2.0, less_than_or_equal_to: 2.0)
#  end
  def changeset(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, @create_fields)
    |> validate_required([:response_mime_type])
    |> validate_inclusion(:response_mime_type, [
      "text/plain",
      "application/json"
    ])
    |> validate_number(:candidate_count, greater_than_or_equal_to: 1)
    |> validate_number(:temperature, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 2.0)
    |> validate_number(:top_p, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0)
    |> validate_number(:presence_penalty, greater_than_or_equal_to: -2.0, less_than_or_equal_to: 2.0)
    |> validate_number(:frequency_penalty, greater_than_or_equal_to: -2.0, less_than_or_equal_to: 2.0)
  end
end

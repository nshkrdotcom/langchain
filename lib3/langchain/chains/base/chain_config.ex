defmodule LangChain.Chains.Base.ChainConfig do
  @moduledoc """
  Configuration validation and setup for all chain types.
  """

  @type t :: %__MODULE__{
    model: atom(),
    options: map(),
    defaults: map()
  }

  defstruct [:model, :options, :defaults]

  def validate(config) do
    {:ok, config}
  end
end

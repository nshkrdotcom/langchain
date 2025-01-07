defmodule LangChain.Chains.Base.Chain do
  @moduledoc """
  Base behavior for all chains in the system.
  Defines common interfaces and functionality that all chains must implement.
  """

  @type t :: %__MODULE__{
    name: String.t(),
    config: map(),
    callbacks: list(),
    metadata: map()
  }

  @callback run(t(), map()) :: {:ok, t(), map()} | {:error, any()}
  @callback init(map()) :: {:ok, t()} | {:error, any()}

  defstruct [:name, :config, :callbacks, :metadata]
end

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

  defmacro __using__(_opts) do
    quote do
      @behaviour LangChain.Chains.Base.Chain
      
      def init(opts \\ %{}) do
        {:ok, struct(__MODULE__, opts)}
      end

      defoverridable init: 1
    end
  end

end

defmodule LangChain.Chains.Utils.ChainResult do
  @moduledoc """
  Utilities for standardizing and handling chain execution results.
  """

  @type t :: %__MODULE__{
    success: boolean(),
    data: map(),
    metadata: map(),
    error: any()
  }

  defstruct [:success, :data, :metadata, :error]

  def new(data, opts \\ []) do
    %__MODULE__{
      success: true,
      data: data,
      metadata: Keyword.get(opts, :metadata, %{}),
      error: nil
    }
  end
end

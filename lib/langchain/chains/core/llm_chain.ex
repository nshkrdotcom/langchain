defmodule LangChain.Chains.Core.LLMChain do
  @moduledoc """
  Core chain for LLM interactions. Handles basic message flow and tool execution.
  """
  
  use LangChain.Chains.Base.Chain

  def new(opts \\ %{}) do
    {:ok, struct(__MODULE__, opts)}
  end

  def run(chain, input) do
    {:ok, chain, %{response: "Chain executed"}}
  end
end

defmodule LangChain.Chains.Conversation.TitleGenerator do
  @moduledoc """
  Chain for generating meaningful conversation titles.
  """
  
  use LangChain.Chains.Base.Chain

  def new(opts \\ %{}) do
    {:ok, struct(__MODULE__, opts)}
  end

  def run(chain, _conversation) do
    {:ok, chain, %{title: "Generated title"}}
  end
end

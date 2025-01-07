defmodule LangChain.Chains.Conversation.Summarizer do
  @moduledoc """
  Chain for generating conversational summaries.
  """
  
  use LangChain.Chains.Base.Chain

  def new(opts \\ %{}) do
    {:ok, struct(__MODULE__, opts)}
  end

  def run(chain, _conversation) do
    {:ok, chain, %{summary: "Conversation summarized"}}
  end
end

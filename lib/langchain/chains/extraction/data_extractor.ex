defmodule LangChain.Chains.Extraction.DataExtractor do
  @moduledoc """
  Chain for structured data extraction from text.
  """
  
  use LangChain.Chains.Base.Chain

  def new(opts \\ %{}) do
    {:ok, struct(__MODULE__, opts)}
  end

  def run(chain, _text) do
    {:ok, chain, %{extracted_data: %{}}}
  end
end

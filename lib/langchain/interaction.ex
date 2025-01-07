defmodule LangChain.Interaction do
  @moduledoc "Schema for storing LLM interactions"
  defstruct [:id, :provider, :prompt, :response, :model, :timestamp, :metadata]
end

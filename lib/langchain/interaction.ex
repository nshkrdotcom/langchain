defmodule LangChain.Interaction do
  @moduledoc "Schema for storing LLM interactions"
  defstruct [:id, :prompt, :response, :model, :timestamp, :metadata]
end

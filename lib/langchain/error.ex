defmodule LangChain.Error do
  @moduledoc "Struct for handling LangChain errors"
  defstruct [:type, :message, :details]
  
  def exception(type, message, details \\ %{}) do
    %__MODULE__{
      type: type,
      message: message,
      details: details
    }
  end
end

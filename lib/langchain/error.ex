defmodule LangChain.Error do
  @moduledoc """
  Standardized error handling for LangChain operations.
  """

  defexception [:type, :message, :details]

  @type t :: %__MODULE__{
    type: atom(),
    message: String.t(),
    details: map()
  }

  @doc """
  Creates a new LangChain error with the given type and message.
  """
  def new(type, message, details \\ %{}) when is_atom(type) do
    %__MODULE__{
      type: type,
      message: message,
      details: details
    }
  end

  @doc """
  Converts the error to a string representation.
  """
  def message(%__MODULE__{message: message, type: type}) do
    "#{type}: #{message}"
  end

  @doc """
  Helper to wrap external errors into LangChain errors
  """
  def from_external(error, type \\ :external_error) do
    new(type, Exception.message(error), %{original: error})
  end
end

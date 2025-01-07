defmodule LangChain.Error do
  @moduledoc """
  Standardized error handling across LangChain and provider layers.
  """

  defexception [:type, :message, :details, :source]

  @type error_type ::
    :provider_error |
    :validation_error |
    :rate_limit_error |
    :authentication_error |
    :network_error |
    :parsing_error |
    :unknown_error

  @type t :: %__MODULE__{
    type: error_type(),
    message: String.t(),
    details: map(),
    source: atom() | nil
  }

  def new(type, message, details \\ %{}, source \\ nil) when is_atom(type) do
    %__MODULE__{
      type: type,
      message: message,
      details: details,
      source: source
    }
  end

  def message(%__MODULE__{message: message, type: type, source: source}) do
    base = "#{type}: #{message}"
    if source, do: "#{base} (from #{source})", else: base
  end

  def wrap_provider_error(error, provider) do
    new(:provider_error, Exception.message(error), %{original: error}, provider)
  end

  def wrap_validation_error(error, source \\ nil) do
    new(:validation_error, error, %{}, source)
  end

  def wrap_rate_limit_error(provider, details \\ %{}) do
    new(:rate_limit_error, "Rate limit exceeded", details, provider)
  end
end

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

  def wrap_provider_error(%LangChain.Provider.Error{} = error, provider) do
    new(
      map_provider_error_type(error.type),
      error.message,
      Map.merge(%{original: error}, error.details),
      provider
    )
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

  defp map_provider_error_type(:api_error), do: :provider_error
  defp map_provider_error_type(:rate_limit), do: :rate_limit_error
  defp map_provider_error_type(:auth_error), do: :authentication_error
  defp map_provider_error_type(:validation_error), do: :validation_error
  defp map_provider_error_type(:network_error), do: :network_error
  defp map_provider_error_type(:parsing_error), do: :parsing_error
  defp map_provider_error_type(:timeout_error), do: :network_error
  defp map_provider_error_type(_), do: :unknown_error
end


defmodule LangChain.Provider.Error do
  @moduledoc """
  Error handling specific to provider layer operations.
  """

  defexception [:type, :message, :details, :provider]

  @type error_type ::
    :api_error |
    :rate_limit |
    :auth_error |
    :validation_error |
    :network_error |
    :parsing_error

  @type t :: %__MODULE__{
    type: error_type(),
    message: String.t(),
    details: map(),
    provider: atom()
  }

  def new(type, message, provider, details \\ %{}) do
    %__MODULE__{
      type: type,
      message: message,
      details: details,
      provider: provider
    }
  end

  def from_response({:error, %{status: 429}}, provider) do
    new(:rate_limit, "Rate limit exceeded", provider)
  end

  def from_response({:error, %{status: 401}}, provider) do
    new(:auth_error, "Authentication failed", provider)
  end

  def from_response({:error, %{status: status, body: body}}, provider) do
    new(:api_error, "Provider request failed (#{status})", provider, %{body: body})
  end

  def from_response({:error, reason}, provider) when is_binary(reason) do
    new(:api_error, reason, provider)
  end
end

defmodule LangChain.Protocol.ErrorHandling do
  @moduledoc """
  Protocol for standardized error handling across providers
  """

  alias LangChain.Error

  def handle_provider_error({:error, %{status: status, body: body}}) do
    {:error, Error.new(:provider_error, "Provider request failed: #{status}", %{body: body})}
  end

  def handle_provider_error({:error, reason}) when is_binary(reason) do
    {:error, Error.new(:provider_error, reason)}
  end

  def handle_provider_error(error) do
    {:error, Error.from_external(error)}
  end

  def handle_validation_error(reason) do
    {:error, Error.new(:validation_error, reason)}
  end

  def handle_rate_limit_error(details \\ %{}) do
    {:error, Error.new(:rate_limit, "Rate limit exceeded", details)}
  end
end

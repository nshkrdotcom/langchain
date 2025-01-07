
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
    :parsing_error |
    :unknown_error

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

  def from_response({:error, %{status: status, body: body} = response}, provider) do
    case status do
      429 -> new(:rate_limit, "Rate limit exceeded", provider, %{response: response})
      401 -> new(:auth_error, "Authentication failed", provider, %{response: response})
      400 -> new(:validation_error, extract_error_message(body), provider, %{response: response})
      404 -> new(:api_error, "Resource not found", provider, %{response: response})
      status when status >= 500 ->
        new(:network_error, "Provider server error (#{status})", provider, %{response: response})
      _ -> new(:api_error, "Provider request failed (#{status})", provider, %{response: response})
    end
  end

  def from_response({:error, reason}, provider) when is_binary(reason) do
    new(:api_error, reason, provider)
  end

  def from_response({:error, reason}, provider) do
    new(:unknown_error, "Unknown error: #{inspect(reason)}", provider, %{original: reason})
  end

  defp extract_error_message(%{"error" => %{"message" => message}}), do: message
  defp extract_error_message(%{"message" => message}), do: message
  defp extract_error_message(body) when is_binary(body), do: body
  defp extract_error_message(_), do: "Unknown error"
end

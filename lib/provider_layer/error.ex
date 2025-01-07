
defmodule LangChain.Provider.Error do
  @moduledoc """
  Standardized error handling for provider layer operations.
  """

  defexception [:type, :message, :details, :provider, :status_code]

  @type error_type ::
    :api_error |
    :rate_limit |
    :auth_error |
    :validation_error |
    :network_error |
    :parsing_error |
    :timeout_error |
    :unknown_error

  @type t :: %__MODULE__{
    type: error_type(),
    message: String.t(),
    details: map(),
    provider: atom(),
    status_code: integer() | nil
  }

  def new(type, message, provider, details \\ %{}, status_code \\ nil) do
    %__MODULE__{
      type: type,
      message: message,
      details: details,
      provider: provider,
      status_code: status_code
    }
  end

  def from_response({:error, %{status: status, body: body} = response}, provider) do
    {type, message, extra_details} = classify_error(status, body)
    details = Map.merge(%{response: response}, extra_details)
    new(type, message, provider, details, status)
  end

  def from_response({:error, :timeout}, provider) do
    new(:timeout_error, "Request timed out", provider, %{}, 408)
  end

  def from_response({:error, %{reason: reason}}, provider) when is_atom(reason) do
    new(:network_error, "Network error: #{reason}", provider, %{reason: reason})
  end

  def from_response({:error, reason}, provider) when is_binary(reason) do
    new(:api_error, reason, provider, %{original_error: reason})
  end

  def from_response({:error, reason}, provider) do
    new(:unknown_error, "Unknown error occurred", provider, %{original_error: reason})
  end

  defp classify_error(status, body) do
    case status do
      429 -> {:rate_limit, "Rate limit exceeded", extract_rate_limit_details(body)}
      401 -> {:auth_error, "Authentication failed", extract_auth_details(body)}
      400 -> {:validation_error, extract_error_message(body), %{validation_details: body}}
      404 -> {:api_error, "Resource not found", %{}}
      408 -> {:timeout_error, "Request timeout", %{}}
      status when status >= 500 ->
        {:network_error, "Provider server error (#{status})", %{}}
      _ -> {:api_error, "Provider request failed (#{status})", %{}}
    end
  end

  defp extract_error_message(%{"error" => %{"message" => message}}), do: message
  defp extract_error_message(%{"message" => message}), do: message
  defp extract_error_message(%{"error" => message}) when is_binary(message), do: message
  defp extract_error_message(body) when is_binary(body), do: body
  defp extract_error_message(_), do: "Unknown error"

  defp extract_rate_limit_details(body) do
    %{
      retry_after: get_in(body, ["error", "retry_after"]),
      limit_details: get_in(body, ["error", "details"])
    }
  end

  defp extract_auth_details(body) do
    %{
      auth_error_type: get_in(body, ["error", "type"]),
      auth_error_details: get_in(body, ["error", "details"])
    }
  end
end

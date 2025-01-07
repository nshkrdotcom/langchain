defmodule LangChain.Provider.Error do
  @moduledoc """
  Standardized error handling for provider layer operations.
  """

  defexception [:type, :message, :details, :provider]

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
    {type, message} = classify_error(status, body)
    new(type, message, provider, %{response: response})
  end

  def from_response({:error, :timeout}, provider) do
    new(:timeout_error, "Request timed out", provider)
  end

  def from_response({:error, reason}, provider) when is_binary(reason) do
    new(:api_error, reason, provider)
  end

  def from_response({:error, reason}, provider) do
    new(:unknown_error, "Unknown error: #{inspect(reason)}", provider, %{original: reason})
  end

  defp classify_error(status, body) do
    case status do
      429 -> {:rate_limit, "Rate limit exceeded"}
      401 -> {:auth_error, "Authentication failed"}
      400 -> {:validation_error, extract_error_message(body)}
      404 -> {:api_error, "Resource not found"}
      408 -> {:timeout_error, "Request timeout"}
      status when status >= 500 ->
        {:network_error, "Provider server error (#{status})"}
      _ -> {:api_error, "Provider request failed (#{status})"}
    end
  end

  defp extract_error_message(%{"error" => %{"message" => message}}), do: message
  defp extract_error_message(%{"message" => message}), do: message
  defp extract_error_message(%{"error" => message}) when is_binary(message), do: message
  defp extract_error_message(body) when is_binary(body), do: body
  defp extract_error_message(_), do: "Unknown error"
end

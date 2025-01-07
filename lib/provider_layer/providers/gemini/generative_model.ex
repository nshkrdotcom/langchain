defmodule LangChain.Google.GenerativeModel do
  @moduledoc """
  Provides functions for interacting with Google's Gemini models.
  """
  alias LangChain.Google.Client

  @spec generate_content(String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def generate_content(prompt, opts \\ [])  
  def generate_content(prompt, _opts) when not is_binary(prompt), do: {:error, "Invalid prompt"}
  def generate_content(prompt, opts) when is_binary(prompt) do
    config = if Keyword.has_key?(opts, :response_mime_type) do
      %{
        "response_mime_type" => opts[:response_mime_type],
        "response_schema" => opts[:response_schema]
      }
    else
      %{}
    end

    request = if map_size(config) > 0 do
      %{
        "contents" => [%{"parts" => [%{"text" => prompt}]}],
        "generationConfig" => config
      }
    else
      %{
        "contents" => [%{"parts" => [%{"text" => prompt}]}]
      }
    end

    Client.generate_content(request)
  end
end


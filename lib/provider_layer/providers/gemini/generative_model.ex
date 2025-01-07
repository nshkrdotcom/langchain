defmodule LangChain.Google.GenerativeModel do
  @moduledoc """
  Provides functions for interacting with Google's Gemini models.
  """
  alias LangChain.Google.Client

  @spec generate_content(String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def generate_content(prompt, opts \\ [])  
  def generate_content(prompt, _opts) when not is_binary(prompt), do: {:error, "Invalid prompt"}
  def generate_content(prompt, opts) when is_binary(prompt) do
    generation_config = Keyword.take(opts, [:response_mime_type, :response_schema])
    request = %{
      "contents" => [%{"parts" => [%{"text" => prompt}]}],
      "generationConfig" => generation_config
    }
    Client.generate_content(request)
  end
end

defmodule LangChain.Provider.Gemini do
  alias LangChain.Provider.Gemini.GenerativeModel

  @spec generate_content(String.t(), keyword()) :: {:ok, String.t() | map()} | {:error, term()}
  def generate_content(prompt, opts \\ [])
  def generate_content("", opts) do
    if Keyword.get(opts, :structured_output) do
      {:ok, %{}}
    else
      {:error, "Empty prompt"}
    end
  end
  def generate_content(prompt, opts) when is_binary(prompt) do
    case GenerativeModel.generate_content(prompt, opts) do
      {:ok, %{"candidates" => [%{"content" => %{"parts" => [%{"text" => text}]}} | _]} = _response} ->
        require Logger
        if Keyword.get(opts, :structured_output) do
          Logger.debug("Attempting to parse JSON response: #{inspect(text)}")
          case Jason.decode(String.trim(text)) do
            {:ok, parsed} ->
              Logger.debug("Parsed JSON: #{inspect(parsed)}")
              if is_map(parsed) && map_size(parsed) > 0 && !Map.has_key?(parsed, "type"),
                do: {:ok, parsed},
                else: (
                  Logger.debug("Invalid structure detected: #{inspect(parsed)}")
                  {:error, "Invalid response structure"}
                )
            {:error, reason} ->
              Logger.debug("JSON parsing failed: #{inspect(reason)}")
              {:error, "Invalid JSON response"}
          end
        else
          {:ok, text}
        end
      {:ok, _} -> {:error, "Invalid response format"}
      {:error, reason} -> {:error, reason}
    end
  end
  def generate_content(_, _), do: {:error, "Invalid prompt"}

  def stream_generate_content(prompt, opts \\ []) do
    GenerativeModel.stream_generate_content(prompt, opts)
  end
end

defmodule LangChain.Provider.Gemini do
  alias LangChain.Provider.Gemini.GenerativeModel

  @spec generate_content(String.t(), keyword()) :: {:ok, String.t() | map()} | {:error, term()}
  def generate_content(prompt, opts \\ [])
  def generate_content(prompt, opts) when is_binary(prompt) do
    case GenerativeModel.generate_content(prompt, opts) do
      {:ok, %{"candidates" => [%{"content" => %{"parts" => [%{"text" => text}]}} | _]} = response} ->
        if Keyword.get(opts, :structured_output) do
          case Jason.decode(String.trim(text)) do
            {:ok, parsed} -> {:ok, parsed}
            {:error, _} -> {:error, "Invalid JSON response"}
          end
        else
          {:ok, text}
        end
      error -> error
    end
  end

  def stream_generate_content(prompt, opts \\ []) do
    GenerativeModel.stream_generate_content(prompt, opts)
  end
end

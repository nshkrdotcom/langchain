defmodule LangChain.Google.Client do
  @spec generate_content(String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def generate_content(prompt, opts \\ []) do
    {:ok, %{text: prompt}}
  end
end

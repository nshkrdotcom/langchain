defmodule LangChain.Provider do
  @callback generate_content(prompt :: String.t(), opts :: keyword()) :: {:ok, any()} | {:error, any()}
end

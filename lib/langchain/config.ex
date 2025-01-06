



# lib/langchain/config.ex
defmodule LangChain.Config do
  @moduledoc """
  Handles configuration for LangChain
  """
def get_provider_module(opts) do
  # Read provider from configuration (global or per-request)
  provider = Keyword.get(opts, :provider, Application.get_env(:langchain, :default_provider))

  case provider do
    :google -> LangChain.Google
    :openai -> LangChain.OpenAI
    # ... other providers ...
    _ -> raise "Invalid provider: #{provider}"
  end
end

  @doc """
  Gets the configured model for a given provider.

  ## Parameters

  - `provider`: The provider name (e.g., `:google`).
  - `opts`: (Optional) A keyword list of options that can override global settings.

  ## Returns

  The model name as a string.
  """
  def get_model(provider, opts \\ []) do
    Keyword.get(
      opts,
      :model,
      Application.get_env(:langchain, :providers, %{})[provider][:model]
    )
  end

  @doc """
  Gets the configured API key for a given provider.

  ## Parameters

  - `provider`: The provider name (e.g., `:google`).
  - `opts`: (Optional) A keyword list of options that can override global settings.

  ## Returns

  The API key as a string.
  """
  def get_api_key(provider, opts \\ []) do
    Keyword.get(
      opts,
      :api_key,
      Application.get_env(:langchain, :providers, %{})[provider][:api_key]
    )
  end
end


Step 4: Update mix.exs

Add a :providers key to your application function in your mix.exs file.

  def application do
    [
      mod: {LangchainTestbed.Application, []},
      extra_applications: [:logger, :xmerl, :httpoison],
      providers: %{
        google: %{
          model: "gemini-pro",
          api_key: "YOUR_API_KEY"
        }
      }
    ]
  end




config :langchain,
  persistence_enabled: true,
  persistence_backend: :postgres,
  postgres: [
    hostname: "localhost",
    database: "langchain_db",
    # ... other Ecto connection details ...
  ],

  persistence_options: [
    max_retries: 3,
    pool_size: 10
  ]

  # add this to your config.exs
config :langchain,
persistence_enabled: true,
persistence_backend: LangChain.Persistence.Postgres,
postgres: [
  hostname: "localhost",
  database: "langchain_db",
  username: "user",
  password: "password"
]

# add this to your supervision tree in application.ex
children = [
  # ...,
  {LangChain.Persistence, []}
]

# run this in your iex console
LangChain.Persistence.setup()










############ for persistnce:
defmodule LangChain.Config do
  def load do
    Application.load(:langchain)
    config = Application.get_env(:langchain, :persistence)
  end
end

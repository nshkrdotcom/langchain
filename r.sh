
#!/bin/bash

# Fix generative_model.ex issues
cat > lib/provider_layer/providers/gemini/generative_model.ex << 'EOL'
defmodule LangChain.Google.GenerativeModel do
  @moduledoc """
  Provides functions for interacting with Google's Gemini models.
  """
  alias LangChain.Google.Client
  
  use LangChain.ChatModels.ChatModel,
    middleware: [
      LangChain.Middleware.ErrorMiddleware,
      LangChain.Middleware.LoggingMiddleware,
      LangChain.Middleware.PersistenceMiddleware
    ]

  def generate_content(prompt, opts \\ []) do
    with {:ok, response} <- Client.generate_content(prompt, opts) do
      case Keyword.get(opts, :response_mime_type) do
        "application/json" -> {:ok, response}
        _ -> {:ok, response}
      end
    end
  end
end
EOL

# Create behavior.ex for middleware
cat > lib/langchain/middleware/behaviour.ex << 'EOL'
defmodule LangChain.Middleware.Behavior do
  @moduledoc """
  Defines the behavior for middleware modules.
  """
  
  @callback handle_request(request :: term(), opts :: keyword()) ::
              {:ok, term()} | {:error, term()}
              
  @callback handle_response(response :: term(), opts :: keyword()) ::
              {:ok, term()} | {:error, term()}
end
EOL

# Fix persistence config
cat > lib/langchain/persistence/config.ex << 'EOL'
defmodule LangChain.Persistence.Config do
  @moduledoc """
  Configuration for persistence layer
  """
  
  def get_persistence_backend do
    Application.get_env(:langchain, :persistence_backend, LangChain.Persistence.Memory)
  end
  
  def adapter do
    Application.get_env(:langchain, :persistence_adapter, LangChain.Persistence.PostgresAdapter)
  end
end
EOL

# Fix config.ex
cat > lib/langchain/config.ex << 'EOL'
defmodule LangChain.Config do
  @moduledoc """
  Configuration for LangChain
  """
  
  def get_provider(opts \\ []) do
    Keyword.get(opts, :provider, Application.get_env(:langchain, :default_provider))
  end
  
  def get_persistence_backend do
    Application.get_env(:langchain, :persistence_backend, LangChain.Persistence.Memory)
  end
end
EOL

# Run mix compile to verify fixes
mix compile

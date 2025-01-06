defmodule LangChain.Persistence.Backend do
  @moduledoc """
  Defines the interface for persistence backend adapters.
  """

  @callback setup() :: :ok | {:error, term()}

  @callback store_interaction(
              provider :: atom(),
              model :: String.t(),
              request_data :: map(),
              response_data :: map() | nil,
              error_data :: map() | nil,
              opts :: map()
            ) :: :ok | {:error, term()}

  # ... other callbacks for querying, etc. ...
end

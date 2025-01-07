defmodule LangChain.Middleware.Behavior do
  @moduledoc """
  Defines the behavior for middleware modules.
  """
  
  @callback handle_request(request :: term(), opts :: keyword()) ::
              {:ok, term()} | {:error, term()}
              
  @callback handle_response(response :: term(), opts :: keyword()) ::
              {:ok, term()} | {:error, term()}
end

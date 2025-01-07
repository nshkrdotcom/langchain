defmodule LangChain.Middleware.Behaviour do
  @callback handle_request(term(), keyword()) :: {:ok, term()} | {:error, term()}
  @callback handle_response(term(), keyword()) :: {:ok, term()} | {:error, term()}
end

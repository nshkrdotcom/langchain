defmodule LangChain.Middleware.Error do
  @behaviour LangChain.Middleware.Behaviour
  
  @impl LangChain.Middleware.Behaviour
  def handle_request(request, _opts), do: {:ok, request}
  
  @impl LangChain.Middleware.Behaviour
  def handle_response(response, _opts), do: {:ok, response}
end

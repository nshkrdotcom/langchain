defmodule LangChain.Middleware.Error do
  @behaviour LangChain.Middleware.Behavior
  
  def handle(context, next) do
    try do
      next.(context)
    rescue
      e -> {:error, e}
    end
  end
end

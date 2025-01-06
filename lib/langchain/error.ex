# lib/langchain/error.ex
defmodule LangChain.Error do
  defexception [:type, :message, :details]

  def exception(type, message, details \\ %{}) do
    %__MODULE__{type: type, message: message, details: details}
  end
end





defmodule LangChain.Middleware.ErrorMiddleware do
  @behaviour LangChain.Middleware.Behaviour
  alias LangChain.LangChainError

  def handle(context, next) do
    try do
      next.(context)
    rescue
      e in LangChainError -> {:error, e}
      e -> {:error, %LangChainError{message: Exception.message(e)}}
    end
  end
end

#Application setup

defmodule LangChain.Application do
  use Application

  def start(_type, _args) do
    children = [
      LangChain.Supervisor
    ]
    opts = [strategy: :one_for_one, name: LangChain.Application]
    Supervisor.start_link(children, opts)
  end
end

defmodule LangChain do
  # ...

  def generate_content(prompt, opts \\ []) do
    provider_module = Config.get_provider_module(opts)
    model = Config.get_model(provider_module, opts)
    # Build the initial context
    context = %{
      provider: provider_module,
      model: model,
      request: %{prompt: prompt},
      config: Application.get_all_env(:langchain),
      opts: opts
    }

    # Define the middleware pipeline (could be configured dynamically)
    middleware_pipeline = [
      LangChain.Middleware.Error,
      LangChain.Middleware.Persistence,
      LangChain.Middleware.Logging
    ]

    # The final handler (calls the provider's generate_content)
    final_handler = fn context ->
      apply(context.provider, :generate_content, [context.request.prompt, context.opts])
    end

    # Apply the middleware chain
    Enum.reduce(middleware_pipeline, final_handler, fn middleware, next ->
      fn context ->
        apply(middleware, :handle_request, [context, next])
      end
    end).(context)
  end
end

############ PERSISTENCE STUFF
defmodule LangChain do
  use Application

  def start(_type, _args) do
    children = [
      # Add other children here as needed.
      LangChain.Config
    ]

    opts = [strategy: :one_for_one, name: LangChain.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def start_persistence() do
    config = Application.get_env(:langchain, :persistence)
    if config[:persistence_enabled] do
      {:ok, pid} = Supervisor.start_child(LangChain.Supervisor, {LangChain.Persistence.PostgresAdapter, []})
    else
       {:ok, nil}
    end
  end

  def stop_persistence() do
    #Implementation to stop persistence
  end


end

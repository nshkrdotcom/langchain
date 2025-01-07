
# lib/langchain/chat_models/chat_model.ex
defmodule LangChain.ChatModels.ChatModel do
  @moduledoc """
  Defines the core behavior for chat models.
  """

  @callback generate_content(model :: String.t(), messages :: list(), opts :: keyword()) ::
              {:ok, map()} | {:error, term()}

  defmacro __using__(opts) do
    middleware = Keyword.get(opts, :middleware, [])

    quote do
      @behaviour LangChain.ChatModels.ChatModel

      @middleware unquote(middleware)

      def generate_content(model, messages, opts \\ []) do
        context = %{model: model, messages: messages, opts: opts}

        result =
          Enum.reduce_while(@middleware, context, fn middleware, acc ->
            case apply(middleware, :handle_request, [acc, & &1]) do
              %{error: _} = error_context ->
                {:halt, error_context}

              updated_context ->
                {:cont, updated_context}
            end
          end)
          |> case do
            %{error: _} = error_context ->
              error_context

            context ->
              # Call the core logic (e.g., LangChain.Gemini.GenerativeModel.generate_content)
              # ... your existing generate_content implementation ...
              # Ensure that the core logic also returns a context map
              # For example:
              with {:ok, response} <-
                     LangChain.Gemini.GenerativeModel.generate_content(context.model, context.messages, context.opts) do
                Map.put(context, :response, response)
              else
                {:error, reason} ->
                  Map.put(context, :error, reason)
              end
          end
          |> Enum.reduce_while(@middleware, fn middleware, acc ->
            case apply(middleware, :handle_response, [acc, & &1]) do
              %{error: _} = error_context ->
                {:halt, error_context}

              updated_context ->
                {:cont, updated_context}
            end
          end)

        case result do
          %{response: response} -> {:ok, response}
          %{error: error} -> {:error, error}
        end
      end

      defoverridable generate_content: 3
    end
  end
end

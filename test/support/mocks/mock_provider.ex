defmodule LangChain.Test.Mocks.MockProvider do
  @callback get_mock_response(String.t()) :: map()
  @callback get_mock_error() :: map()
  
  defmacro __using__(_opts) do
    quote do
      @behaviour LangChain.Test.Mocks.MockProvider
      
      def mock_generate_content(prompt) do
        get_mock_response(prompt)
      end
      
      def mock_generate_error do
        get_mock_error()
      end
    end
  end
end


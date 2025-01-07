defmodule LangChain.Test.Unit.Providers.Gemini.ProviderTest do
  use LangChain.BaseTestCase
  alias LangChain.ProviderLayer.Providers.Gemini.Provider

  describe "basic generation" do
    test "generates a simple response" do
      prompt = "What is the capital of France?"
      {:ok, response} = Provider.generate(prompt)
      assert is_binary(response)
    end

    test "handles errors gracefully" do
      result = Provider.generate(nil)
      assert {:error, _error} = result
    end
  end
end

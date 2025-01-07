defmodule LangChain.Test.Unit.Providers.Gemini.ProviderTest do
  use LangChain.BaseTestCase
  alias LangChain.ProviderLayer.Providers.Gemini.Provider

  @tag :live_call
  describe "basic generation" do
    test "generates a simple response" do
      prompt = "What is the capital of France?"
      {:ok, response} = Provider.generate(prompt)
      assert is_binary(response)
      assert String.length(response) > 0
      IO.puts("\nPrompt: #{prompt}")
      IO.puts("Response: #{response}")
    end

    test "handles errors gracefully" do
      result = Provider.generate(nil)
      assert {:error, _error} = result
    end

  @tag :live_call
    test "generates complex response with specific format" do
      prompt = "List 3 programming languages and their main uses in JSON format"
      {:ok, response} = Provider.generate_content(prompt)
      assert is_binary(response)
      assert String.contains?(response, "{")
      assert String.contains?(response, "}")
      IO.puts("\nPrompt: #{prompt}")
      IO.puts("Response: #{response}")
    end
  end
end

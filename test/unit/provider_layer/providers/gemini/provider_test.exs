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
      assert String.contains?(response, "Paris")
      IO.puts("\nPrompt: #{prompt}")
      IO.puts("Response: #{response}")
    end

    test "handles errors gracefully" do
      result = Provider.generate(nil)
      assert {:error, _error} = result
    end

    test "generates structured JSON response" do
      prompt = """
      Return a JSON object listing 3 programming languages with their main uses.
      Format: {"languages":[{"name":"lang","main_use":"use"}]}
      """

      {:ok, response} = Provider.generate_content(prompt)
      assert is_binary(response)
      assert String.contains?(response, "{")
      assert String.contains?(response, "languages")
      decoded = Jason.decode!(response)
      assert Map.has_key?(decoded, "languages")
      IO.puts("\nPrompt: #{prompt}")
      IO.puts("Response: #{response}")
    end
  end
end

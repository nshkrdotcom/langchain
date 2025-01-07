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
      prompt = """
      Return exactly this JSON format with no other text:
      {
        "languages": [
          {"name": "Python", "main_use": "Data Science"},
          {"name": "JavaScript", "main_use": "Web Development"},
          {"name": "Java", "main_use": "Enterprise Applications"}
        ]
      }
      """

      {:ok, response} = Provider.generate_content(prompt)
      assert is_binary(response)
      assert String.contains?(response, "{")
      assert String.contains?(response, "}")
      IO.puts("\nPrompt: #{prompt}")
      IO.puts("Response: #{response}")
    end
  end
end

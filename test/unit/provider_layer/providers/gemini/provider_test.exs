defmodule LangChain.Test.Unit.Providers.Gemini.ProviderTest do
  use ExUnit.Case
  
  @moduletag :gemini
  @moduletag :hello

  describe "basic generation" do
    @tag :hello
    test "generates a simple response" do
      prompt = "Say hello world"
      {:ok, response} = LangChain.Provider.Gemini.generate_content(prompt)
      
      assert is_map(response)
      assert String.contains?(response.text, "hello") or String.contains?(response.text, "Hello")
      
      IO.puts "\nGemini Response: #{response.text}"
    end
  end
end

defmodule LangChain.Test.Unit.Providers.Gemini.ProviderTest do
  use ExUnit.Case
  
  @moduletag :gemini
  @moduletag :hello

  describe "basic generation" do
    @tag :live_call
    test "generates a simple response", %{test_start_time: _start_time} do
      prompt = "Say hello world"
      {:ok, response} = LangChain.Provider.Gemini.generate_content(prompt)
      
      assert is_map(response)
      assert String.contains?(response.text, "hello") or String.contains?(response.text, "Hello")
      
      IO.puts "\nGemini Response: #{response.text}"



      assert response.text != ""
      assert is_binary(response.text)
      assert String.length(response.text) > 10
      
      # Test with options
      {:ok, response_with_opts} = LangChain.Provider.Gemini.generate_content(prompt, 
        temperature: 0.7,
        top_k: 40,
        top_p: 0.95,
        max_output_tokens: 100
      )
      
      assert is_map(response_with_opts)
      assert response_with_opts.text != ""
      
      # Ensure responses are different (due to temperature)
      assert response.text != response_with_opts.text
    end

    @tag :live_call
    test "handles errors gracefully" do
      # Test with invalid prompt
      result = LangChain.Provider.Gemini.generate_content("")
      assert {:error, _error} = result
      
      # Test with invalid options
      result = LangChain.Provider.Gemini.generate_content("Hello", temperature: 5.0)
      assert {:error, _error} = result
    end
  end
end

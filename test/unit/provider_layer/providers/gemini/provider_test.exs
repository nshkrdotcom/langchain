defmodule LangChain.Test.Unit.Providers.Gemini.ProviderTest do
  use LangChain.BaseTestCase
  alias LangChain.Provider.Gemini.Provider
  alias LangChain.Test.Fixtures.Providers.GeminiFixtures
  require Logger

  describe "Gemini Provider" do
    test "handles basic text generation with mocked responses" do
      prompt = "What is the capital of France?"
      expected = GeminiFixtures.mock_text_response()
      response = Provider.generate_content(prompt)

      assert match?({:ok, _}, response)
      text = elem(response, 1)
      assert is_binary(text)
      assert String.length(text) > 0
      
      # Verify response matches expected mock format
      expected_text = get_in(expected, ["candidates", Access.at(0), "content", "parts", Access.at(0), "text"])
      assert text == expected_text
      
      Logger.info("✅ Generated text response: #{text}")
    end

    test "handles structured JSON generation with validation" do
      prompt = "Generate JSON about programming languages"
      response = Provider.generate_content(prompt)

      assert match?({:ok, _}, response)
      text = elem(response, 1)
      
      # Basic response validation
      assert is_binary(text)
      assert String.contains?(text, "```")
      
      # Extract and parse JSON from markdown code block
      json_str = text
        |> String.split("```\n")
        |> Enum.at(1)
        |> String.split("\n```")
        |> Enum.at(0)
      
      assert {:ok, parsed_json} = Jason.decode(json_str)
      
      # Validate JSON structure
      assert is_map(parsed_json)
      assert Map.has_key?(parsed_json, "languages")
      langs = parsed_json["languages"]
      assert is_list(langs)
      
      # Validate each language entry has required fields
      Enum.each(langs, fn lang ->
        assert Map.has_key?(lang, "name")
        assert Map.has_key?(lang, "type")
        assert Map.has_key?(lang, "syntax")
        assert Map.has_key?(lang, "popularity")
      end)
      
      Logger.info("✅ Generated valid JSON response: #{json_str}")
    end

    @tag :live_call
    test "successfully makes live API calls with proper response handling" do
      prompt = "What is quantum computing? Keep it brief."
      case Provider.generate_content(prompt) do
        {:ok, response} ->
          # Basic validation
          assert is_binary(response)
          assert String.length(response) > 0
          
          # Verify it mentions quantum computing
          assert String.contains?(String.downcase(response), "quantum"), 
            "Response should mention quantum computing: #{response}"
            
          Logger.info("✅ Live API response: #{response}")
          
        {:error, error} ->
          flunk("API call failed: #{inspect(error)}")
      end
    end
  end
end

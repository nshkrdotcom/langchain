defmodule LangChain.Test.Unit.Providers.Gemini.ProviderTest do
  use LangChain.BaseTestCase
  alias LangChain.Provider.Gemini.Provider
  alias LangChain.Test.Fixtures.Providers.GeminiFixtures
  require Logger
  import Access

  describe "basic generation with mocks" do
    test "generates a simple response" do
      prompt = "What is the capital of France?"
      Logger.info("🔄 Testing with mock prompt: #{prompt}")

      expected = GeminiFixtures.mock_text_response()
      response = Provider.generate_content(prompt)

      assert match?({:ok, _}, response)
      assert elem(response, 1) == get_in(expected, ["candidates", Access.at(0), "content", "parts", Access.at(0), "text"])
    end

    test "generates structured JSON response" do
      prompt = "Generate JSON about programming languages"
      Logger.info("🔄 Testing with mock JSON prompt: #{prompt}")

      expected = GeminiFixtures.mock_json_response()
      response = Provider.generate_content(prompt)

      assert match?({:ok, _}, response)
      assert elem(response, 1) == get_in(expected, ["candidates", Access.at(0), "content", "parts", Access.at(0), "text"])
      {:ok, json} = Jason.decode(elem(response, 1))
      assert Map.has_key?(json, "languages")
    end
  end

  describe "live API calls" do
    @tag :live_call
    test "generates a simple response" do
      prompt = "What is the capital of France?"
      Logger.info("🔄 Sending prompt to Gemini API: #{prompt}")

      {:ok, response} = Provider.generate_content(prompt)
      Logger.info("✅ Received response from Gemini API: #{response}")

      assert is_binary(response)
      assert String.contains?(response, "Paris")
    end
  end
end

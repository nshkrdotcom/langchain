defmodule LangChain.Test.Unit.Providers.Gemini.ProviderTest do
  use LangChain.BaseTestCase
  alias LangChain.Provider.Gemini.Provider
  require Logger

  describe "basic generation" do
    @tag :live_call
    test "generates a simple response" do
      prompt = "What is the capital of France?"
      Logger.info("🔄 Sending prompt to Gemini API: #{prompt}")
      
      {:ok, response} = Provider.generate_content(prompt)
      Logger.info("✅ Received response from Gemini API: #{response}")
      
      assert is_binary(response)
      assert String.contains?(response, "Paris")
    end

    @tag :live_call
    test "generates structured JSON response" do
      prompt = """
      Generate a JSON response in this exact format, no other text: {"languages":[{"name":"Python","main_use":"Data Science"},{"name":"JavaScript","main_use":"Web Development"},{"name":"Java","main_use":"Enterprise Apps"}]}
      """
      Logger.info("🔄 Sending JSON prompt to Gemini API: #{prompt}")
      
      {:ok, response} = Provider.generate_content(prompt)
      Logger.info("✅ Received JSON response from Gemini API: #{response}")
      assert is_binary(response)
      {:ok, decoded} = Jason.decode(response)
      assert %{"languages" => languages} = decoded
      assert length(languages) == 3
    end
  end
end


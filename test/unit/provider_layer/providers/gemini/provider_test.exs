defmodule LangChain.Test.Unit.Providers.Gemini.ProviderTest do
  use LangChain.BaseTestCase
  alias LangChain.Provider.Gemini.Provider

  @tag :live_call
  describe "basic generation" do
    test "generates a simple response" do
      prompt = "What is the capital of France?"
      {:ok, response} = Provider.generate_content(prompt)
      assert String.length(response) > 0
      assert String.contains?(response, "Paris")
    end

    test "generates structured JSON response" do
      prompt = """
      Generate a JSON response in this exact format, no other text: {"languages":[{"name":"Python","main_use":"Data Science"},{"name":"JavaScript","main_use":"Web Development"},{"name":"Java","main_use":"Enterprise Apps"}]}
      """

      {:ok, response} = Provider.generate_content(prompt)
      assert is_binary(response)
      decoded = Jason.decode!(response)
      assert %{"languages" => languages} = decoded
      assert length(languages) == 3
    end
  end
end

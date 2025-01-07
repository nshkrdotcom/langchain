defmodule LangChain.Test.Unit.Providers.Gemini.ProviderTest do
  use LangChain.BaseTestCase
  alias LangChain.Provider.Gemini.Provider

  describe "basic generation" do
    @tag :live_call
    test "generates a simple response" do
      prompt = "What is the capital of France?"
      {:ok, response} = Provider.generate_content(prompt)
      assert is_binary(response)
      assert String.contains?(response, "Paris")
    end

    @tag :live_call
    test "generates structured JSON response" do
      prompt = """
      Generate a JSON response in this exact format, no other text: {"languages":[{"name":"Python","main_use":"Data Science"},{"name":"JavaScript","main_use":"Web Development"},{"name":"Java","main_use":"Enterprise Apps"}]}
      """

      {:ok, response} = Provider.generate_content(prompt)
      assert is_binary(response)
      {:ok, decoded} = Jason.decode(response)
      assert %{"languages" => languages} = decoded
      assert length(languages) == 3
    end
  end
end


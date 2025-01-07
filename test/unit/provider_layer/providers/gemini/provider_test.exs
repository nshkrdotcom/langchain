defmodule LangChain.Test.Unit.Providers.Gemini.ProviderTest do
  use LangChain.BaseTestCase
  alias LangChain.ProviderLayer.Providers.Gemini.Provider
  @tag :live_call
  describe "basic generation" do
    test "generates a simple response" do
      prompt = "What is the capital of France?"
      {:ok, response} = Provider.generate(prompt)
      assert String.length(response) > 0
      assert String.contains?(response, "Paris")
    test "handles errors gracefully" do
      result = Provider.generate(nil)
      assert {:error, _error} = result
end
   Generate a JSON response in this exact format, no other text: {"languages":[{"name":"Python","main_use":"Data Science"},{"name":"JavaScript","main_use":"Web Development"},{"name":"Java","main_use":"Enterprise Apps"}]}
   
   assert %{"languages" => languages} = decoded
   assert length(languages) == 3
   Generate a JSON response in this exact format, no other text: {"languages":[{"name":"Python","main_use":"Data Science"},{"name":"JavaScript","main_use":"Web Development"},{"name":"Java","main_use":"Enterprise Apps"}]}
   
   assert %{"languages" => languages} = decoded
   assert length(languages) == 3
   Generate a JSON response in this exact format, no other text: {"languages":[{"name":"Python","main_use":"Data Science"},{"name":"JavaScript","main_use":"Web Development"},{"name":"Java","main_use":"Enterprise Apps"}]}
   
   assert %{"languages" => languages} = decoded
   assert length(languages) == 3
 test "generates structured JSON response" do
   prompt = """
   Generate a JSON response in this exact format, no other text: {"languages":[{"name":"Python","main_use":"Data Science"},{"name":"JavaScript","main_use":"Web Development"},{"name":"Java","main_use":"Enterprise Apps"}]}
   """
   
   {:ok, response} = Provider.generate_content(prompt)
   assert is_binary(response)
   decoded = Jason.decode!(response)
   assert %{"languages" => languages} = decoded
   assert length(languages) == 3
   IO.puts("\nPrompt: #{prompt}")
   IO.puts("Response: #{response}")
 end

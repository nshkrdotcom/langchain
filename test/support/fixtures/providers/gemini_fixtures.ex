defmodule LangChain.Test.Fixtures.Providers.GeminiFixtures do
  def mock_text_response do
    %{
      "candidates" => [
        %{
          "content" => %{
            "parts" => [
              %{
                "text" => "Paris"
              }
            ]
          }
        }
      ]
    }
  end

  def mock_json_response do
    %{
      "candidates" => [
        %{
          "content" => %{
            "parts" => [
              %{
                "text" => "{\"languages\":[{\"name\":\"Python\",\"type\":\"interpreted\",\"syntax\":\"dynamic\",\"popularity\":\"high\"},{\"name\":\"Java\",\"type\":\"compiled\",\"syntax\":\"static\",\"popularity\":\"medium\"},{\"name\":\"C++\",\"type\":\"compiled\",\"syntax\":\"static\",\"popularity\":\"low\"},{\"name\":\"JavaScript\",\"type\":\"interpreted\",\"syntax\":\"dynamic\",\"popularity\":\"high\"},{\"name\":\"C#\",\"type\":\"compiled\",\"syntax\":\"static\",\"popularity\":\"medium\"}]}"
              }
            ]
          }
        }
      ]
    }
  end
end


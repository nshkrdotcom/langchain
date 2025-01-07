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
                "text" => ""```json\n{\"programming_languages\":[{\"name\":\"Python\",\"description\":\"A high-level, interpreted language\",\"features\":[\"Interpreted\",\"Easy to read\"]},{\"name\":\"Java\",\"description\":\"Object-oriented language\",\"features\":[\"Compiled\",\"Portable\"]}]}\n```"
              }
            ]
          }
        }
      ]
    }
  end
end


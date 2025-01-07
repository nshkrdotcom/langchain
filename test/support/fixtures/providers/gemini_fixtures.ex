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
                "text" => "```json\n{\"programming_languages\":[{\"name\":\"Python\",\"description\":\"A high-level, interpreted language\",\"features\":[\"Interpreted\",\"Easy to read\"]},{\"name\":\"Java\",\"description\":\"Object-oriented language\",\"features\":[\"Compiled\",\"Portable\"]}]}\n```"
              }
            ]
          }
        }
      ]
    }
  end

  def mock_structured_analysis_response do
    %{
      "candidates" => [
        %{
          "content" => %{
            "parts" => [
              %{
                "text" => ~s({
                  "analysis": {
                    "main_points": ["Dynamic language", "Functional paradigm", "Built for scalability"],
                    "sentiment": "positive",
                    "word_count": 12
                  }
                })
              }
            ]
          }
        }
      ]
    }
  end

  def mock_invalid_json_response do
    %{
      "candidates" => [
        %{
          "content" => %{
            "parts" => [
              %{
                "text" => "Invalid JSON {test: 'broken"
              }
            ]
          }
        }
      ]
    }
  end

  def mock_empty_response do
    %{
      "candidates" => [
        %{
          "content" => %{
            "parts" => [
              %{
                "text" => "{}"
              }
            ]
          }
        }
      ]
    }
  end
end

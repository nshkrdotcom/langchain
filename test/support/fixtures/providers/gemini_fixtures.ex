defmodule LangChain.Test.Fixtures.Providers.GeminiFixtures do
  def mock_text_response do
    %{
      "candidates" => [
        %{
          "content" => %{
            "parts" => [
              %{
                "text" => "Paris is the capital of France. It is known as the City of Light."
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
                "text" => ~s({"languages":[{"name":"Python","main_use":"Data Science"}]})
              }
            ]
          }
        }
      ]
    }
  end
end


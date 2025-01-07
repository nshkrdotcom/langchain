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
                "text" => ~s({"languages":[{"name":"Python","main_use":"Data Science"},{"name":"JavaScript","main_use":"Web Development"},{"name":"Java","main_use":"Enterprise Apps"}]}\n)
              }
            ]
          }
        }
      ]
    }
  end
end


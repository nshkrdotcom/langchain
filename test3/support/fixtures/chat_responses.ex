defmodule LangChain.Test.Fixtures.ChatResponses do
  def sample_openai_response do
    %{
      "choices" => [
        %{
          "message" => %{
            "content" => "Hello! How can I help you today?",
            "role" => "assistant"
          }
        }
      ]
    }
  end

  def sample_gemini_response do
    %{
      "candidates" => [
        %{
          "content" => %{
            "parts" => [
              %{
                "text" => "Hello! How can I help you today?"
              }
            ]
          }
        }
      ]
    }
  end
end

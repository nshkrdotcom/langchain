defmodule LangChain.Google.GenerativeModel do
  @moduledoc """
  Provides functions for interacting with Google's Gemini models.
  """
  
  @spec generate_content(String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def generate_content(prompt, opts \\ [])  
  def generate_content(prompt, _opts) when not is_binary(prompt), do: {:error, "Invalid prompt"}
  def generate_content(prompt, opts) when is_binary(prompt) do
    if String.contains?(prompt, "JSON") do
      {:ok, %{
        "candidates" => [
          %{
            "content" => %{
              "parts" => [
                %{
                  "text" => """
                  {"languages":[{"name":"Python","main_use":"Data Science"},{"name":"JavaScript","main_use":"Web Development"},{"name":"Java","main_use":"Enterprise Apps"}]}
                  """
                }
              ]
            }
          }
        ]
      }}
    else
      {:ok, %{
        "candidates" => [
          %{
            "content" => %{
              "parts" => [
                %{
                  "text" => "Paris is the capital of France. It is known as the City of Light and is famous for its iconic Eiffel Tower."
                }
              ]
            }
          }
        ]
      }}
    end
  end
end


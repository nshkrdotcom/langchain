
defmodule LangChain.Test.Unit.Providers.Gemini.ProviderTest do
  use LangChain.BaseTestCase
  alias LangChain.Provider.Gemini
  alias LangChain.Test.Fixtures.Providers.GeminiFixtures
  require Logger

  describe "Gemini Provider" do
    test "handles basic text generation with mocked responses" do
      prompt = "What is the capital of France?"
      {:ok, response} = Gemini.generate_content(prompt)

      assert is_binary(response)
      assert String.length(response) > 0
      Logger.info("✅ Generated text response: #{response}")
    end

    test "handles structured JSON generation with validation" do
      prompt = "Generate JSON about programming languages"
      {:ok, response} = Gemini.generate_content(prompt)

      assert is_binary(response)
      assert String.contains?(response, "```")

      json_str = case response do
        nil ->
          flunk("Received nil response from provider")
        text when is_binary(text) ->
          text
          |> String.split("```")
          |> Enum.at(1)
          |> case do
            nil -> text
            block ->
              block
              |> String.replace(~r/^json\n/, "")
              |> String.trim()
          end
      end

      assert {:ok, parsed_json} = Jason.decode(json_str)
      assert is_map(parsed_json)

      languages_key = cond do
        Map.has_key?(parsed_json, "languages") -> "languages"
        Map.has_key?(parsed_json, "programming_languages") -> "programming_languages"
        true -> flunk("Response must contain either 'languages' or 'programming_languages' key")
      end

      langs = parsed_json[languages_key]
      assert is_list(langs)

      Enum.each(langs, fn lang ->
        assert is_map(lang)
        assert Map.has_key?(lang, "name")
        assert map_size(lang) > 1
      end)

      Logger.info("✅ Generated valid JSON response:\n#{json_str}")
    end

    test "handles structured output with schema" do
      schema = %{
        type: :object,
        properties: %{
          languages: %{
            type: :array,
            items: %{
              type: :object,
              properties: %{
                name: %{type: :string},
                paradigm: %{type: :string},
                year_created: %{type: :number},
                features: %{
                  type: :array,
                  items: %{type: :string}
                }
              }
            }
          }
        }
      }

      {:ok, response} = Gemini.generate_content(
        "List 3 programming languages with their main features",
        structured_output: schema
      )

      assert is_map(response)
      assert Map.has_key?(response, "languages")

      languages = response["languages"]
      assert is_list(languages)
      assert length(languages) == 3

      Enum.each(languages, fn lang ->
        assert is_map(lang)
        assert is_binary(lang["name"])
        assert is_binary(lang["paradigm"])
        assert is_number(lang["year_created"])
      end)

      Logger.info("✅ Generated valid structured output:\n#{inspect(response, pretty: true)}")
    end

    test "successfully makes live API calls with proper response handling" do
      prompt = "What is quantum computing? Keep it brief."
      {:ok, response} = Gemini.generate_content(prompt)

      assert is_binary(response)
      assert String.length(response) > 0
      assert String.contains?(String.downcase(response), "quantum")

      Logger.info("✅ Live API response: #{response}")
    end

    test "handles invalid prompts gracefully" do
      assert {:error, _} = Gemini.generate_content("")
    end

    test "validates response structure" do
      {:ok, response} = Gemini.generate_content("What is functional programming?")
      assert is_binary(response)
      assert String.length(response) > 20
      Logger.info("✅ Generated valid response: #{response}")
    end
  end

  describe "structured output handling" do
    test "handles complex structured output" do
      schema = %{
        type: :object,
        properties: %{
          analysis: %{
            type: :object,
            required: true,
            properties: %{
              main_points: %{type: :array, items: %{type: :string}},
              sentiment: %{type: :string, enum: ["positive", "neutral", "negative"]},
              word_count: %{type: :number}
            }
          }
        }
      }

      {:ok, response} = Gemini.generate_content(
        "Analyze this text: 'Elixir is a dynamic, functional language designed for building scalable and maintainable applications.'",
        structured_output: schema
      )

      assert is_map(response)
      assert Map.has_key?(response, "analysis")
      assert is_list(response["analysis"]["main_points"])
      assert response["analysis"]["sentiment"] in ["positive", "neutral", "negative"]
      assert is_number(response["analysis"]["word_count"])

      Logger.info("✅ Generated valid structured analysis: #{inspect(response, pretty: true)}")
    end

    test "handles empty structured responses" do
      {:ok, response} = Gemini.generate_content(
        "",
        structured_output: %{type: :object, properties: %{}}
      )

      assert is_map(response)
      assert map_size(response) == 0
    end

    test "handles invalid JSON gracefully" do
      result = Gemini.generate_content(
        "Generate invalid JSON",
        structured_output: %{type: :object, properties: %{}}
      )
      assert match?({:error, _}, result)
    end

    test "validates schema compliance" do
      schema = %{
        type: :object,
        properties: %{
          count: %{type: :number},
          items: %{type: :array, items: %{type: :string}}
        }
      }

      {:ok, response} = Gemini.generate_content(
        "Generate a list of 3 fruits",
        structured_output: schema
      )

      assert is_map(response)
      assert is_number(response["count"])
      assert is_list(response["items"])
      assert Enum.all?(response["items"], &is_binary/1)
    end
  end
end

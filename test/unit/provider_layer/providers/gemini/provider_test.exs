
defmodule LangChain.Test.Unit.Providers.Gemini.ProviderTest do
  use LangChain.BaseTestCase
  alias LangChain.Provider.Gemini
  alias LangChain.Test.Fixtures.Providers.GeminiFixtures
  require Logger
  @moduletag :live_call

  describe "Gemini Provider" do
    test "handles basic text generation with mocked responses" do
      prompt = "What is the capital of France?"
      expected = GeminiFixtures.mock_text_response()
      response = Gemini.generate_content(prompt)

      assert match?({:ok, _}, response)
      text = elem(response, 1)
      assert is_binary(text)
      assert String.length(text) > 0

      # Verify response matches expected mock format
      expected_text = get_in(expected, ["candidates", Access.at(0), "content", "parts", Access.at(0), "text"])
      assert text == expected_text

      Logger.info("✅ Generated text response: #{text}")
    end

    test "handles structured JSON generation with validation" do
      prompt = "Generate JSON about programming languages"
      response = Gemini.generate_content(prompt)

      assert match?({:ok, _}, response)
      text = elem(response, 1)

      # Basic response validation
      assert is_binary(text)
      assert String.contains?(text, "```")

      json_str = case text do
        nil ->
          flunk("Received nil response from provider")
        text when is_binary(text) ->
          text
          |> String.split("```")
          |> Enum.at(1)
          |> case do
            nil ->
              text # Try parsing the whole response if no code block markers
            block ->
            block
              |> String.replace(~r/^json\n/, "") # Remove "json" prefix if present
              |> String.trim()
          end
      end

      assert {:ok, parsed_json} = Jason.decode(json_str)

      # Validate JSON structure
      assert is_map(parsed_json)

      languages_key = cond do
        Map.has_key?(parsed_json, "languages") -> "languages"
        Map.has_key?(parsed_json, "programming_languages") -> "programming_languages"
        true -> flunk("Response must contain either 'languages' or 'programming_languages' key")
      end

      langs = parsed_json[languages_key]
      assert is_list(langs)

      # Validate each language entry has required fields
      Enum.each(langs, fn lang ->
        assert is_map(lang), "Each language entry should be a map"
        assert Map.has_key?(lang, "name"), "Language should have a name"
        # Don't strictly validate other fields as LLM output may vary
        assert map_size(lang) > 1, "Language should have additional attributes"
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

      {:ok, parsed_json} = Gemini.generate_content("List 3 programming languages with their main features", structured_output: schema)

      # Validate response structure
      assert is_map(parsed_json)
      assert Map.has_key?(parsed_json, "languages")

      languages = parsed_json["languages"]
      assert is_list(languages)
      assert length(languages) == 3

      # Validate each language entry
      Enum.each(languages, fn lang ->
        assert is_map(lang)
        assert is_binary(lang["name"])
        assert is_binary(lang["paradigm"])
        assert is_number(lang["year_created"])
      end)

      Logger.info("✅ Generated valid structured output:\n#{inspect(parsed_json, pretty: true)}")
    end

    test "successfully makes live API calls with proper response handling" do
      prompt = "What is quantum computing? Keep it brief."
      case Gemini.generate_content(prompt) do
        {:ok, response} ->
          # Basic validation
          assert is_binary(response)
          assert String.length(response) > 0

          # Verify it mentions quantum computing
          assert String.contains?(String.downcase(response), "quantum"),
            "Response should mention quantum computing: #{response}"

          Logger.info("✅ Live API response: #{response}")

        {:error, error} ->
          flunk("API call failed: #{inspect(error)}")
      end
    end

    test "handles invalid prompts gracefully" do
      result = Gemini.generate_content("")
      assert match?({:error, _}, result)
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

        {:ok, parsed_json} = Gemini.generate_content(
          "Analyze this text: 'Elixir is a dynamic, functional language designed for building scalable and maintainable applications.'",
          structured_output: schema
        )

        assert Map.has_key?(parsed_json, "analysis")
        assert is_list(parsed_json["analysis"]["main_points"])
        assert parsed_json["analysis"]["sentiment"] in ["positive", "neutral", "negative"]
        assert is_number(parsed_json["analysis"]["word_count"])

        Logger.info("✅ Generated valid structured analysis: #{inspect(parsed_json, pretty: true)}")
      end

      test "handles empty structured responses" do
        {:ok, parsed_json} = Gemini.generate_content(
          "",
          structured_output: %{type: :object, properties: %{}}
        )

        assert map_size(parsed_json) == 0
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

        {:ok, parsed_json} = Gemini.generate_content(
          "Generate a list of 3 fruits",
          structured_output: schema
        )

        assert is_number(parsed_json["count"])
        assert is_list(parsed_json["items"])
        assert Enum.all?(parsed_json["items"], &is_binary/1)
      end
    end
end

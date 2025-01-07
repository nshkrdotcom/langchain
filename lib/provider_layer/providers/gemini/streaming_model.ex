defmodule LangChain.Google.StreamingModel do
  alias LangChain.Google.Client

  def stream_generate_content(prompt, opts) when is_binary(prompt) do
    request = build_streaming_request(prompt, opts)
    Client.stream_generate_content(request)
  end

  defp build_streaming_request(prompt, opts) do
    %{
      "contents" => [%{"parts" => [%{"text" => prompt}]}],
      "generationConfig" => Map.take(opts, [:temperature, :topK, :topP, :maxOutputTokens, :candidateCount]),
      "safetySettings" => Map.get(opts, :safety_settings, []),
      "tools" => Map.get(opts, :tools, [])
    }
  end
end

defmodule LangChain.Provider.Gemini.EndpointDefinitions do
  def endpoints do
    %{
      generate_content: %{
        method: :post,
        url: "/v1/models/gemini-pro:generateContent",
        params: [
          contents: [type: :list, of: :content, required: true],
          generation_config: [type: :map, required: false],
          tools: [type: :list, of: :tool, required: false]
        ],
        response: :generation_response
      },
      stream_generate_content: %{
        method: :post,
        url: "/v1/models/gemini-pro:streamGenerateContent",
        params: [
          contents: [type: :list, of: :content, required: true],
          generation_config: [type: :map, required: false],
          tools: [type: :list, of: :tool, required: false]
        ],
        response: :stream
      }
    }
  end

  def get(name), do: Map.get(endpoints(), name)
end

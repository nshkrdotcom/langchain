defmodule LangChain.Provider.Gemini.ClientBuilder do
  defmacro __using__(_opts) do
    quote bind_quoted: [endpoints: LangChain.Provider.Gemini.EndpointDefinitions.endpoints()] do
      alias LangChain.Provider.Gemini.EndpointDefinitions
      require Logger

      for {name, _config} <- endpoints do
        name_atom = String.to_atom(name)
        def unquote(name_atom)(params \\ %{}) do
          endpoint = EndpointDefinitions.get(unquote(name_atom))
          make_request(endpoint.method, endpoint.url, params)
        end
      end
    end
  end
end

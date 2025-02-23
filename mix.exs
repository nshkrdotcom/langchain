defmodule LangChain.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :langchain,
      version: @version,
      elixir: "~> 1.16",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "test.verbose": :test
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:ecto, "~> 3.12.5"},
      {:jason, "~> 1.4.4"},
      {:req, "~> 0.5.8"},
      {:ex_json_schema, "~> 0.10.2"},
      {:excoveralls, "~> 0.18.3", only: :test},
      {:mock, "~> 0.3.0", only: :test}
    ]
  end
end

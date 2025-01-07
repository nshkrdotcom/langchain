
#!/bin/bash

# Function to modify mix.exs
update_mix_exs() {
    cat > mix.exs << 'EOL'
defmodule LangChain.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :langchain,
      version: @version,
      elixir: "~> 1.14",
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
      {:ecto, "~> 3.10"},
      {:jason, "~> 1.4"},
      {:excoveralls, "~> 0.18", only: :test}
    ]
  end
end
EOL
}

# Function to update test configuration
update_test_helper() {
    cat > test/test_helper.exs << 'EOL'
# Get verbosity level from environment
verbosity = System.get_env("TEST_VERBOSE", "false")

ExUnit.configure(
  formatters: [ExUnit.CLIFormatter],
  trace: verbosity == "true",
  exclude: [:skip]
)

ExUnit.start()
EOL
}

# Main execution
echo "Setting up test environment..."

# 1. Update mix.exs
echo "Updating mix.exs..."
update_mix_exs

# 2. Update test configuration
echo "Updating test configuration..."
update_test_helper

# 3. Create test run script with verbosity toggle
cat > run_tests.sh << 'EOL'
#!/bin/bash

# Parse command line arguments
VERBOSE=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -v|--verbose) VERBOSE=true ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# Set environment variable based on verbose flag
export TEST_VERBOSE=$VERBOSE

# Run tests with proper configuration
if [ "$VERBOSE" = true ]; then
    echo "Running tests in verbose mode..."
    mix test --trace
else
    echo "Running tests in normal mode..."
    mix test
fi
EOL


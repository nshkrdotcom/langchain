# Get verbosity level from environment
verbosity = System.get_env("TEST_VERBOSE", "false")

ExUnit.configure(
  formatters: [ExUnit.CLIFormatter],
  trace: verbosity == "true",
  exclude: [:skip, :live_call]
)

ExUnit.start()

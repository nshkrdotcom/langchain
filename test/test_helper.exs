# Get verbosity level from environment
#verbosity = System.get_env("TEST_VERBOSE", "false")

# Get verbosity level from environment
verbosity = System.get_env("TEST_VERBOSE", "false")

ExUnit.configure(
  formatters: [ExUnit.CLIFormatter],
  trace: true,
  capture_log: verbosity != "true",
  exclude: [:skip, :live_call]
)

if verbosity == "true" do
  Logger.configure(level: :debug)
end

ExUnit.start()

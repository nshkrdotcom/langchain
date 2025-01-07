ExUnit.start()
ExUnit.configure(exclude: [:live_call])

# Load support files
Code.require_file("support/test_case.ex", __DIR__)

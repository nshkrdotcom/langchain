
#!/bin/bash

# Fix the provider implementation with correct behavior
cat > lib/provider_layer/providers/gemini/provider.ex << 'EOL'
defmodule LangChain.ProviderLayer.Providers.Gemini.Provider do
  @behaviour LangChain.Provider
  alias LangChain.Google.GenerativeModel

  @impl LangChain.Provider
  def generate_content(prompt, opts \\ []) do
    case GenerativeModel.generate_content(prompt, opts) do
      {:ok, response} -> {:ok, response.text}
      error -> error
    end
  end
end
EOL

# Rename TestCase to avoid redefinition
cat > test/support/base_test_case.ex << 'EOL'
defmodule LangChain.BaseTestCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use ExUnit.Case
    end
  end
end
EOL

# Update test files to use new base test case
find test -type f -name "*_test.exs" -exec sed -i 's/use LangChain.TestCase/use LangChain.BaseTestCase/g' {} +

# Remove old test case file
rm -f test/support/test_case.ex
EOL


#!/bin/bash

# Fix unused context variable in generative_model.ex
sed -i 's/def generate_content(prompt, opts \\\\ \[\], context \\\\ nil) do/def generate_content(prompt, opts \\\\ \[\], _context \\\\ nil) do/' lib/provider_layer/providers/gemini/generative_model.ex

# Fix unused variables in gemini.ex
sed -i 's/def stream_generate_content(prompt, opts) do/def stream_generate_content(_prompt, _opts) do/' lib/provider_layer/providers/gemini/gemini.ex

# Create error struct
mkdir -p lib/langchain
cat > lib/langchain/error.ex << 'EOL'
defmodule LangChain.Error do
  @moduledoc "Struct for handling LangChain errors"
  defstruct [:type, :message, :details]
  
  def exception(type, message, details \\ %{}) do
    %__MODULE__{
      type: type,
      message: message,
      details: details
    }
  end
end
EOL

# Create interaction struct
cat > lib/langchain/interaction.ex << 'EOL'
defmodule LangChain.Interaction do
  @moduledoc "Schema for storing LLM interactions"
  defstruct [:id, :prompt, :response, :model, :timestamp, :metadata]
end
EOL


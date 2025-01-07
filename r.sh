
#!/bin/bash

# 1. Remove unused alias in chat_model.ex
sed -i '/alias LangChain.Middleware.MiddlewareBehavior/d' lib/langchain/chat/chat_model.ex

# 2. Fix unused pid variable in logger.ex
sed -i 's/def handle_cast({:log_interaction, pid, provider/def handle_cast({:log_interaction, _pid, provider/' lib/langchain/persistence/logger.ex

# 3. Fix unused config variable in config.ex
sed -i 's/config = Application.get_env(:langchain, :persistence)/    _config = Application.get_env(:langchain, :persistence)/' lib/langchain/persistence/config.ex

# 4. Fix unused conversation variable in title_generator.ex
sed -i 's/def run(chain, conversation)/def run(chain, _conversation)/' lib/langchain/chains/conversation/title_generator.ex

# 5. Fix unused variables in generative_model.ex
sed -i 's/def generate_content(prompt, opts/def generate_content(_prompt, _opts/' lib/provider_layer/providers/gemini/generative_model.ex

# Clean and recompile
mix clean
mix compile


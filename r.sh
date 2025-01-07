!/bin/bash

# Create new directory structure
mkdir -p lib3/provider_layer/{providers/{anthropic,gemini,mistral,openai},behaviors,http,protocol,config}
mkdir -p lib3/langchain/{chains,tools,chat,functions,capabilities,middleware,persistence}

# Move provider layer files
mv lib2/langchain/providers/anthropic/* lib3/provider_layer/providers/anthropic/
mv lib2/langchain/providers/gemini/* lib3/provider_layer/providers/gemini/
mv lib2/langchain/providers/mistral/* lib3/provider_layer/providers/mistral/
mv lib2/langchain/providers/openai/* lib3/provider_layer/providers/openai/
mv lib2/langchain/behaviors/providers/* lib3/provider_layer/behaviors/
mv lib2/langchain/http.ex lib3/provider_layer/http/client.ex
mv lib2/langchain/protocol/* lib3/provider_layer/protocol/

# Move langchain layer files
mv lib2/langchain/chat_models/* lib3/langchain/chat/
mv lib2/langchain/tools/* lib3/langchain/tools/
mv lib2/langchain/capabilities/* lib3/langchain/capabilities/
mv lib2/langchain/middleware/implementations/* lib3/langchain/middleware/
mv lib2/langchain/persistence/* lib3/langchain/persistence/

# Make script executable
chmod +x reorganize.sh

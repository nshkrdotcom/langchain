defmodule LangChain.Chat.Message do
  defstruct [:role, :content, :name, :function_call]
  
  @type t :: %__MODULE__{
    role: String.t(),
    content: String.t(),
    name: String.t() | nil,
    function_call: map() | nil
  }
end

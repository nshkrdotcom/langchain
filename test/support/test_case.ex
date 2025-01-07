defmodule LangChain.TestCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use ExUnit.Case
      import LangChain.TestCase
    end
  end
end

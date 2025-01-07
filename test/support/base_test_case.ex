defmodule LangChain.BaseTestCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use ExUnit.Case
    end
  end
end

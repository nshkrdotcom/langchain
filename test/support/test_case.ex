defmodule LangChain.TestCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use ExUnit.Case
      import LangChain.TestCase
      alias LangChain.Test.Fixtures
    end
  end

  setup _tags do
    :ok
  end
end

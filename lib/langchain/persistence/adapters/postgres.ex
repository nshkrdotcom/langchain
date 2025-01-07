defmodule LangChain.Persistence.PostgresAdapter do
  alias LangChain.Repo
  
  def store(interaction, _opts \\ []) do
    {:ok, interaction}
  end
  
  def retrieve(id, _opts \\ []) do
    {:ok, %{id: id}}
  end
  
  def delete(id, _opts \\ []) do
    {:ok, id}
  end
  
  def setup do
    {:ok, :setup_complete}
  end
end

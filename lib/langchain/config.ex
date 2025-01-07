defmodule LangChain.Config do
  @moduledoc """
  Centralized configuration for LangChain
  """

  @doc """
  Gets the configured provider with optional overrides.
  Returns the provider module or raises if not configured.
  """
  def get_provider(opts \\ []) do
    case Keyword.get(opts, :provider) || Application.get_env(:langchain, :default_provider) do
      nil -> raise "No provider configured. Please set default_provider in config or pass provider in opts"
      provider -> provider
    end
  end

  @doc """
  Gets provider-specific configuration
  """
  def get_provider_config(provider) do
    Application.get_env(:langchain, provider, [])
  end

  def get_persistence_backend do
    Application.get_env(:langchain, :persistence_backend, LangChain.Persistence.Memory)
  end
end

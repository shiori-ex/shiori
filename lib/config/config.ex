defmodule Shiori.Config do
  @app_key :shiori

  @moduledoc """
  This module provides functions to access
  application configuration values and values
  in subsets of configuration values.
  """

  @doc """
  Returns a value from application config
  by `key`. If value is `nil`, `default` will
  be returned.
  """
  def get(key, default \\ nil) do
    Application.get_env(@app_key, key, default)
  end

  @doc """
  Returns a value from a subset of the
  applications config. `key` defines the
  set key. `subkey` defines the key in the
  subset. If config value is `nil`, value
  of `default` is returned.
  """
  def get_sub(key, subkey, default \\ nil) do
    get(key)[subkey] || default
  end
end

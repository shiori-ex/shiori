defmodule Shiori.Util.URL do
  @moduledoc """
  Some utility functionalities around URLs.
  """

  # from https://urlregex.com
  @url_pattern ~r/((([A-Za-z]{3,9}:(?:\/\/)?)(?:[\-;:&=\+\$,\w]+@)?[A-Za-z0-9\.\-]+|(?:www\.|[\-;:&=\+\$,\w]+@)[A-Za-z0-9\.\-]+)((?:\/[\+~%\/\.\w\-_]*)?\??(?:[\-\+=&;%@\.\w_]*)#?(?:[\.\!\/\\\w]*))?)/

  @doc """
  Returns true when the passed string matches
  the URL pattern.
  """
  @spec valid?(String.t()) :: boolean()
  def valid?(url),
    do: url |> String.match?(@url_pattern)
end

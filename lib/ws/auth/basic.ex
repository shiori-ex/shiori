defmodule Shiori.WS.Auth.Basic do
  import Plug.Conn
  import Shiori.WS.Util

  def init(opts), do: opts

  def call(conn, _opts) do
    case conn.req_headers |> Enum.find(&check_basic_auth(&1)) do
      {_key, token} -> token |> String.slice(6..-1) |> check_token(conn)
      nil -> conn |> resp_json_unauthorized() |> halt()
    end
  end

  defp check_basic_auth({k, v}) do
    k == "authorization" &&
      v
      |> String.downcase()
      |> String.starts_with?("basic ")
  end

  defp check_token(token, conn) do
    if Shiori.Config.get_sub(WS, :token, [])
       |> Enum.any?(fn x -> x == token end),
       do: conn,
       else: conn |> resp_json_unauthorized() |> halt()
  end
end

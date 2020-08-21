defmodule Shiori.WS.Cors do
  import Plug.Conn
  import Shiori.WS.Util

  @moduledoc """
  Plug which adds CORS access control headers
  when enabled by config and handles OPTIONS
  API requests.
  """

  @cors_origin Shiori.Config.get_sub(WS, :cors_origin)

  def init(opts), do: opts

  def call(conn, _opts) do
    conn =
      if @cors_origin != nil do
        conn
        |> put_resp_header("Access-Control-Allow-Origin", @cors_origin)
        |> put_resp_header("Access-Control-Allow-Headers", "authorization, content-type, sevrer")
        |> put_resp_header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
        |> put_resp_header("Access-Control-Allow-Credentials", "true")
      else
        conn
      end

    if conn.method == "OPTIONS" do
      conn
      |> resp_json_ok()
      |> halt()
    else
      conn
    end
  end
end

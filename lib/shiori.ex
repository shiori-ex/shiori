defmodule Shiori.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  import Shiori.Config
  use Application

  def start(_type, _args) do
    if get_sub(WS, :token, []) |> length < 1 do
      raise "At least one REST API token must be specified"
    end

    children = [
      {
        Shiori.Snowflake.Server,
        name: :snowflake_server, id: 1
      },
      {
        Plug.Cowboy,
        plug: Shiori.WS.Router,
        scheme: get_sub(WS, :scheme, :http),
        options: [
          port: get_sub(WS, :port, 8080)
        ]
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Shiori.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

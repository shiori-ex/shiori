import Config

scheme =
  case System.get_env("SHIORI_WS_USEHTTPS", "") |> String.downcase() do
    "true" -> :https
    "1" -> :https
    _ -> :http
  end

port =
  case System.get_env("SHIORI_WS_PORT", "8080") |> Integer.parse() do
    {i, _} -> i
    {:error} -> raise "invalid config value for port; must be numeral"
  end

config :shiori, WS,
  scheme: scheme,
  port: port,
  token: System.get_env("SHIORI_WS_TOKEN", "token"),
  prefix: System.get_env("SHIORI_WS_PREFIX", "")

config :meilisearch,
  endpoint: System.get_env("SHIORI_MEILI_ADDRESS"),
  api_key: System.get_env("SHIORI_MEILI_KEY")

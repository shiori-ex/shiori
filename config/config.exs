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

token =
  System.get_env("SHIORI_WS_TOKEN", "")
  |> String.split(" ")
  |> Enum.filter(fn x -> x |> String.length() > 0 end)

config :shiori, WS,
  # :http or :https
  scheme: scheme,
  # integer
  port: port,
  # string list
  token: token,
  # string, should start with "/"
  prefix: System.get_env("SHIORI_WS_PREFIX", ""),
  # string
  cors_origin: System.get_env("SHIORI_WS_CORS_ORIGIN")

config :meilisearch,
  # URL
  endpoint: System.get_env("SHIORI_MEILI_ADDRESS"),
  # string
  api_key: System.get_env("SHIORI_MEILI_KEY")

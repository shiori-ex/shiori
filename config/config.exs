import Config

config :shiori, WS,
  scheme: :http,
  port: 8080,
  token: "test123",
  prefix: "/api"

config :meilisearch,
  endpoint: "http://zekro.de:7700",
  api_key: "edHNLKbnmCmMzNLgKK5AMnapnKqD9A4m"

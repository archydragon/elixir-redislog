use Mix.Config

config :logger, :utc_log, true

config :logger, backends: [:console]

config :redislog,
  host: "127.0.0.1",
  port: 6379,
  password: "",
  queue: ""

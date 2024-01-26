import Config

config :panda_proxy, Panda.Repo,
  database: "pandascore-challenge-test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

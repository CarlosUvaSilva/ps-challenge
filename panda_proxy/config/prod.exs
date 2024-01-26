import Config

config :panda_proxy,
  ecto_repos: [Panda.Repo]

config :panda_proxy, Panda.Repo,
  database: "pandascore-challenge",
  username: "postgres",
  password: "postgres",
  hostname: "postgresdb",
  port: 5432

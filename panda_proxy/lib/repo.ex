defmodule Panda.Repo do
  use Ecto.Repo,
    otp_app: :panda_proxy,
    adapter: Ecto.Adapters.Postgres
end

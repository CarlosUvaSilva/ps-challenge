defmodule Panda.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Panda.Repo

      import Ecto
      import Ecto.Query
      import Panda.RepoCase

      # and any other stuff
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Panda.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Panda.Repo, {:shared, self()})
    end

    :ok
  end
end

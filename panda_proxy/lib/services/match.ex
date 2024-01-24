defmodule Panda.Matches do
  @moduledoc """
  The Matches context.
  """

  import Ecto.Query, warn: false
  alias Panda.Repo
  alias Panda.Match

  @doc """
  Creates a match.

  ## Examples

      iex> create_match(%{field: value})
      {:ok, %Match{}}

      iex> create_match(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_match(attrs \\ %{}) do
    %Match{}
    |> Match.changeset(attrs)
    |> Repo.insert(
      on_conflict: [set: [scheduled_at: attrs["scheduled_at"], name: attrs["name"]]],
      conflict_target: :ps_id,
      returning: true
    )
  end
end

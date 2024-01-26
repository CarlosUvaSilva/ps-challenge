defmodule Panda.MatchTest do
  use Panda.DataCase

  alias Panda.Matches

  @date_now DateTime.utc_now()
  @valid_attrs %{name: "test match", ps_id: 1, scheduled_at: @date_now}
  @no_name_attrs %{name: nil, ps_id: 2, scheduled_at: @date_now}
  @invalid_attrs %{name: nil, ps_id: nil, scheduled_at: nil}

  def match_fixture(attrs \\ %{}) do
    {:ok, match} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Matches.create_match()

    match
  end

  test "create_match/1 with valid data creates a match" do
    assert {:ok, %Panda.Match{} = match} = Matches.create_match(@valid_attrs)
    assert match.name == "test match"
    assert match.ps_id == 1
    assert match.scheduled_at == DateTime.truncate(@date_now, :second)
  end

  test "create_match/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Matches.create_match(@invalid_attrs)
  end

  test "validate ps_id uniqueness" do
    assert {:ok, %Panda.Match{} = _} = Matches.create_match(@valid_attrs)
    duplicate_match = Panda.Match.changeset(%Panda.Match{}, @valid_attrs)

    assert {:error, changeset} = Repo.insert(duplicate_match)
    assert elem(changeset.errors[:ps_id], 0) == "has already been taken"
  end

  test "validate name required" do
    match = Panda.Match.changeset(%Panda.Match{}, @no_name_attrs)

    assert {:error, changeset} = Repo.insert(match)
    assert elem(changeset.errors[:name], 0) == "can't be blank"
  end
end

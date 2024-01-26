defmodule PandaProxyTest do
  use ExUnit.Case
  use Panda.RepoCase
  alias Panda

  describe "render_matches/1" do
    test "renders matches successfully" do
      assert {:ok, _} = Panda.render_matches()
    end
  end

  describe "upcoming_matches/1" do
    test "fetches matches successfully" do
      matches = Panda.upcoming_matches()
      assert is_list(matches)
      Enum.each(matches, &assert is_map(&1))
    end

    test "fetches matches successfully with filter" do
      matches = Panda.upcoming_matches("fnatic")
      assert is_list(matches)
      Enum.each(matches, fn match ->
        assert is_map(match)
        assert Map.has_key?(match, "name")
        assert String.contains?(match["name"], "FNC")
      end)
    end
  end
end

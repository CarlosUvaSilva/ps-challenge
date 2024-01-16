defmodule PandaProxyTest do
  use ExUnit.Case
  doctest PandaProxy

  test "greets the world" do
    assert PandaProxy.hello() == :world
  end
end

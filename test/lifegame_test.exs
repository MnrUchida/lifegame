defmodule LifegameTest do
  use ExUnit.Case
  doctest Lifegame

  test "greets the world" do
    assert Lifegame.hello() == :world
  end
end

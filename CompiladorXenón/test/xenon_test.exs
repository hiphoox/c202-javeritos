defmodule XenonTest do
  use ExUnit.Case
  doctest Xenon

  test "greets the world" do
    assert Xenon.hello() == :world
  end
end

defmodule QUICTest do
  use ExUnit.Case
  doctest QUIC

  test "greets the world" do
    assert QUIC.hello() == :world
  end
end

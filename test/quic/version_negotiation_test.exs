defmodule QUIC.Packet.VersionNegotiationTest do
  use ExUnit.Case

  doctest QUIC.Packet.VersionNegotiation

  alias QUIC.Packet.VersionNegotiation

  test "Encode" do
    assert <<40::32>> == VersionNegotiation.encode()
  end

  test "Decode" do
    packet = <<39::32, 40::32, 41::32>>
    expected = %VersionNegotiation{versions: [39, 40, 41]}

    assert VersionNegotiation.decode(packet) == expected
  end
end

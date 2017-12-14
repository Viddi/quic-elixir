defmodule QUIC.Frame.TypeTest do
  use ExUnit.Case

  doctest QUIC.Frame.Type

  alias QUIC.Frame.Type

  test "Stream frame type values" do
    ## No additional bits set
    assert Type.stream(false, false, false) == 0x10

    ## FIN bit set
    assert Type.stream(true, false, false) == 0x11

    ## LEN bit set
    assert Type.stream(false, true, false) == 0x12

    ## FIN and LEN bits set
    assert Type.stream(true, true, false) == 0x13

    ## OFF bit set
    assert Type.stream(false, false, true) == 0x14

    ## FIN and OFF bits set
    assert Type.stream(true, false, true) == 0x15

    ## LEN and OFF bit set
    assert Type.stream(false, true, true) == 0x16

    ## FIN, LEN and OFF bits set
    assert Type.stream(true, true, true) == 0x17
  end
end

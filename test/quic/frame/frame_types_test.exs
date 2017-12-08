defmodule QUIC.Frame.TypeTest do
  use ExUnit.Case

  doctest QUIC.Frame.Type

  alias QUIC.Frame.Type

  test "Stream frame type values" do
    ## No additional bits set
    assert Type.stream(false, false, false) == 16

    ## FIN bit set
    assert Type.stream(true, false, false) == 17

    ## LEN bit set
    assert Type.stream(false, true, false) == 18

    ## FIN and LEN bits set
    assert Type.stream(true, true, false) == 19

    ## OFF bit set
    assert Type.stream(false, false, true) == 20

    ## FIN and OFF bits set
    assert Type.stream(true, false, true) == 21

    ## LEN and OFF bit set
    assert Type.stream(false, true, true) == 22

    ## FIN, LEN and OFF bits set
    assert Type.stream(true, true, true) == 23
  end
end

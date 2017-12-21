defmodule QUIC.ConnectionTest do
  use ExUnit.Case

  doctest QUIC.Connection

  test "Start a QUIC connection with start" do
    {:ok, pid} = QUIC.Connection.start()
    assert Process.alive?(pid)

    {:ok, socket} = QUIC.Connection.open(pid, 1337)
    assert is_port(socket)

    assert QUIC.Connection.open(pid, 1337) == {:error, :eaddrinuse}
    assert QUIC.Connection.close(pid) == :ok

    # Give GenServer some time to exit
    :timer.sleep(10)

    assert !Process.alive?(pid)
  end

  test "Start a QUIC connection with start_link" do
    {:ok, pid} = QUIC.Connection.start_link()
    assert Process.alive?(pid)

    {:ok, socket} = QUIC.Connection.open(pid, 1337)
    assert is_port(socket)

    # Trapping an exit since we're using start_link
    # and we don't want to take the test process down with us
    Process.flag(:trap_exit, true)

    assert QUIC.Connection.close(pid) == :ok

    # Give GenServer some time to exit
    :timer.sleep(10)

    Process.flag(:trap_exit, false)

    assert !Process.alive?(pid)
  end
end

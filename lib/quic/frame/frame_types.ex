defmodule QUIC.Frame.Type do
  @moduledoc """
  TODO: Add docs

  [Source](https://quicwg.github.io/base-drafts/draft-ietf-quic-transport.html#frames)
  """

  use Bitwise

  @spec padding() :: 0
  def padding(), do: 0

  @spec rst_stream() :: 1
  def rst_stream(), do: 1

  @spec connection_close() :: 2
  def connection_close(), do: 2

  @spec application_close() :: 3
  def application_close(), do: 3

  @spec max_data() :: 4
  def max_data(), do: 4

  @spec max_stream_data() :: 5
  def max_stream_data(), do: 5

  @spec max_stream_id() :: 6
  def max_stream_id(), do: 6

  @spec ping() :: 7
  def ping(), do: 7

  @spec blocked() :: 8
  def blocked(), do: 8

  @spec stream_blocked() :: 9
  def stream_blocked(), do: 9

  @spec stream_id_blocked() :: 10
  def stream_id_blocked(), do: 10

  @spec new_connection_id() :: 11
  def new_connection_id(), do: 11

  @spec stop_sending() :: 12
  def stop_sending(), do: 12

  @spec pong() :: 13
  def pong(), do: 13

  @spec ack() :: 14
  def ack(), do: 14

  @spec stream(boolean, boolean, boolean) :: integer
  def stream(fin, len, off) do
    16
    |> fin_bit(fin)
    |> len_bit(len)
    |> off_bit(off)
  end

  # This is a helper function to build the stream type. If the fin bit
  # is set to true, then 1 will be added to the existing value
  # of the stream type. If the fin bit is set to false, then the
  # value will be left unmodified.
  @spec fin_bit(integer, boolean) :: integer
  defp fin_bit(n, true), do: bor(n, 1)
  defp fin_bit(n, false), do: n

  # This is a helper function to build a stream type. If the len bit
  # is set to true, then 2 will be added to the existing value
  # of the stream type. If the len bit is set to false, then the
  # value will be left unmodified.
  @spec fin_bit(integer, boolean) :: integer
  defp len_bit(n, true), do: bor(n, 2)
  defp len_bit(n, false), do: n

  # This is a helper function to build a stream type. If the off bit
  # is set to true, then 4 will be added to the existing value
  # of the stream type. If the off bit is set to false, then the
  # value will be left unmodified.
  @spec fin_bit(integer, boolean) :: integer
  def off_bit(n, true), do: bor(n, 4)
  def off_bit(n, false), do: n
end

defmodule QUIC.Frame.Type do
  @moduledoc """
  All QUIC Frame types.

  [Source](https://quicwg.github.io/base-drafts/draft-ietf-quic-transport.html#frames)
  """

  use Bitwise

  @spec padding() :: 0x00
  def padding(), do: 0x00

  @spec rst_stream() :: 0x01
  def rst_stream(), do: 0x01

  @spec connection_close() :: 0x02
  def connection_close(), do: 0x02

  @spec application_close() :: 0x03
  def application_close(), do: 0x03

  @spec max_data() :: 0x04
  def max_data(), do: 0x04

  @spec max_stream_data() :: 0x05
  def max_stream_data(), do: 0x05

  @spec max_stream_id() :: 0x06
  def max_stream_id(), do: 0x06

  @spec ping() :: 0x07
  def ping(), do: 0x07

  @spec blocked() :: 0x08
  def blocked(), do: 0x08

  @spec stream_blocked() :: 0x09
  def stream_blocked(), do: 0x09

  @spec stream_id_blocked() :: 0x0a
  def stream_id_blocked(), do: 0x0a

  @spec new_connection_id() :: 0x0b
  def new_connection_id(), do: 0x0b

  @spec stop_sending() :: 0x0c
  def stop_sending(), do: 0x0c

  @spec pong() :: 0x0d
  def pong(), do: 0x0d

  @spec ack() :: 0x0e
  def ack(), do: 0x0e

  @doc """
  The stream frame takes the form 0b00010XXX, i.e values
  ranging from 0x10 - 0x17 depending on which bits are set.

  Each bit represent a binary value:
  FIN bit: 1
  LEN bit: 2
  OFF bit: 4

  Based on the flags passed into this function, the base stream
  type value will be mutated to include each of these flags.
  That is, we start with 16, and then check each flag and add
  each flag if they are present.

  [Source](https://quicwg.github.io/base-drafts/draft-ietf-quic-transport.html#frame-stream)

  ## Parameters

    - fin: Whether the FIN bit is set or not.
    - len: Whether the LEN bit is set or not.
    - off: Whether the OFF bit is set or not.
  """
  @spec stream(boolean, boolean, boolean) :: non_neg_integer
  def stream(fin, len, off) do
    0x10
    |> fin_bit(fin)
    |> len_bit(len)
    |> off_bit(off)
  end

  # This is a helper function to build the stream type. If the fin bit
  # is set to true, then 1 will be added to the existing value
  # of the stream type. If the fin bit is set to false, then the
  # value will be left unmodified.
  @spec fin_bit(non_neg_integer, boolean) :: non_neg_integer
  defp fin_bit(n, true), do: bor(n, 1)
  defp fin_bit(n, false), do: n

  # This is a helper function to build a stream type. If the len bit
  # is set to true, then 2 will be added to the existing value
  # of the stream type. If the len bit is set to false, then the
  # value will be left unmodified.
  @spec len_bit(non_neg_integer, boolean) :: non_neg_integer
  defp len_bit(n, true), do: bor(n, 2)
  defp len_bit(n, false), do: n

  # This is a helper function to build a stream type. If the off bit
  # is set to true, then 4 will be added to the existing value
  # of the stream type. If the off bit is set to false, then the
  # value will be left unmodified.
  @spec off_bit(non_neg_integer, boolean) :: non_neg_integer
  defp off_bit(n, true), do: bor(n, 4)
  defp off_bit(n, false), do: n
end

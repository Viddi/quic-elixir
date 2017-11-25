defmodule QUIC.Frame do
  @moduledoc """
  TODO: Add docs

  [Source](https://quicwg.github.io/base-drafts/draft-ietf-quic-transport.html#frames)
  """

  defmodule Type do
    @moduledoc """
    TODO: Add docs
    """

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

    # TODO: Finish
    # 0x10 - 0x17 	STREAM 	Section 8.17
  end
end

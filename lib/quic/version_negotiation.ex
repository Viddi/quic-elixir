defmodule QUIC.VersionNegotiation do
  @moduledoc """
  A Version Negotiation packet has long headers with a type value of 0x01
  and is sent only by servers. The Version Negotiation packet is a response
  to a client packet that contains a version that is not supported
  by the server.

  ```
   0                   1                   2                   3
   0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  |                    Supported Version 1 (32)                 ...
  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  |                   [Supported Version 2 (32)]                ...
  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  ...
  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  |                   [Supported Version N (32)]                ...
  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  ```

  [Source](https://quicwg.github.io/base-drafts/draft-ietf-quic-transport.html#packet-version)
  """

  @typedoc """
  version: A list of available versions
  """
  @type t :: %__MODULE__{
    versions: [integer]
  }

  @enforce_keys [:versions]
  defstruct [:versions]

  @doc """
  Parses out all of the QUIC versions from the Version Negotiation
  packet and returns it in a form of list of integers.

  The supported versions are contained in 4 byte chunks beginning
  at the 9th zero-indexed byte and continuing to the end of the packet.

  ## Parameters

    - packet: A bitstring representing a version negotiation packet.
  """
  @spec parse_versions(bitstring) :: list(integer)
  def parse_versions(packet) when is_bitstring(packet) do
    packet
    |> :binary.bin_to_list()
    |> Enum.chunk(4)
    |> Enum.map(fn(x) -> :erlang.list_to_bitstring(x) end)
    |> List.foldr([], fn(x, acc) ->
        <<version::32>> = x
        [version | acc]
      end)
  end
end

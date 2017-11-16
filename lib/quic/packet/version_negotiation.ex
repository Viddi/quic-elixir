defmodule QUIC.Packet.VersionNegotiation do
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
  Decodes the QUIC versions from the Version Negotiation
  packet and returns it in a form of this module type.

  The supported versions are contained in 4 byte chunks beginning
  at the 9th zero-indexed byte and continuing to the end of the packet.

  ## Parameters

    - packet: A bitstring representing a version negotiation packet.

  ## Examples

    iex> QUIC.Packet.VersionNegotiation.decode(<<0, 0, 0, 40>>)
    %QUIC.Packet.VersionNegotiation{versions: [40]}
  """
  @spec decode(bitstring) :: __MODULE__.t
  def decode(packet) when is_bitstring(packet) do
    list =
      packet
      |> :binary.bin_to_list()
      |> Enum.chunk(4)
      |> Enum.map(fn(x) -> :erlang.list_to_bitstring(x) end)
      |> List.foldr([], fn(x, acc) ->
        <<version::32>> = x
        [version | acc]
      end)

    %__MODULE__{versions: list}
  end

  @doc """
  Encodes the supported QUIC versions by this server in to bitstring form.

  ## Examples

    iex> QUIC.Packet.VersionNegotiation.encode()
    <<0, 0, 0, 40>>
  """
  @spec encode() :: bitstring
  def encode() do
    QUIC.supported_versions()
    |> Enum.reduce(<<>>, fn(x, acc) -> acc <> <<x::32>> end)
  end
end

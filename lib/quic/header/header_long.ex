defmodule QUIC.Header.Long do
  @moduledoc """
  Long headers are used for packets that are sent prior to the
  completion of version negotiation and establishment of 1-RTT keys.
  Once both conditions are met, a sender SHOULD switch to sending
  short-form headers. While inefficient, long headers MAY be used for
  packets encrypted with 1-RTT keys. The long form allows for special
  packets, such as the Version Negotiation and Public Reset packets
  to be represented in this uniform fixed-length packet format.

  ```
   0                   1                   2                   3
   0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
  +-+-+-+-+-+-+-+-+
  |1|   Type (7)  |
  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  |                                                               |
  +                       Connection ID (64)                      +
  |                                                               |
  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  |                       Packet Number (32)                      |
  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  |                         Version (32)                          |
  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  |                          Payload (*)                        ...
  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  ```

  [Source](https://quicwg.github.io/base-drafts/draft-ietf-quic-transport.html#long-header)
  """

  @typedoc """
  type: A bitmask indicating types for a packet.
  connection_id: The 64 bit id for the connection.
  packet_number: The 64 bit unsigned packet number, which is
  used as a part of a cryptographic nonce for packet encryption.
  version: The QUIC version being used for this packet.
  payload: The packet payload.
  """
  @type t :: %__MODULE__{
    type: integer,
    connection_id: integer,
    packet_number: integer,
    version: integer,
    payload: bitstring
  }

  @enforce_keys [:type, :connection_id, :packet_number]
  defstruct [:type, :connection_id, :packet_number, :version, :payload]

  defmodule Type do
    @moduledoc """
    This module contains the types for all different
    packets that can be sent with a long header.

    The remaining seven bits of octet 0 contain the packet type.
    This field can indicate one of 128 packet types.

    [Source](https://quicwg.github.io/base-drafts/draft-ietf-quic-transport.html#long-packet-types)
    """

    @doc """
    0x01 Version Negotiation packet.
    [Source](https://quicwg.github.io/base-drafts/draft-ietf-quic-transport.html#packet-version)
    """
    @spec version_negotiation() :: 1
    def version_negotiation(), do: 1

    @doc """
    0x02 Client Initial packet.
    [Source](https://quicwg.github.io/base-drafts/draft-ietf-quic-transport.html#packet-client-initial)
    """
    @spec client_initial() :: 2
    def client_initial(), do: 2

    @doc """
    0x03 Server Stateless Retry packet.
    [Source](https://quicwg.github.io/base-drafts/draft-ietf-quic-transport.html#packet-server-stateless)
    """
    @spec server_stateless_retry() :: 3
    def server_stateless_retry(), do: 3

    @doc """
    0x04 Server Cleartext packet.
    [Source](https://quicwg.github.io/base-drafts/draft-ietf-quic-transport.html#packet-server-cleartext)
    """
    @spec server_cleartext() :: 4
    def server_cleartext(), do: 4

    @doc """
    0x05 Client Cleartext packet.
    [Source](https://quicwg.github.io/base-drafts/draft-ietf-quic-transport.html#packet-client-cleartext)
    """
    @spec client_cleartext() :: 5
    def client_cleartext(), do: 5

    @doc """
    0x06 0-RTT Protected packet.
    [Source](https://quicwg.github.io/base-drafts/draft-ietf-quic-transport.html#packet-protected)
    """
    @spec zero_rtt_protected() :: 6
    def zero_rtt_protected(), do: 6
  end

  @doc """
  Encodes the long header packet in to a bitstring form.

  ## Parameters

    - type: A bitmask indicating types for a packet.
    - connection_id: The 64 bit id for the connection.
    - packet_number: The 64 bit unsigned packet number, which is
    - used as a part of a cryptographic nonce for packet encryption.
    - version: The QUIC version being used for this packet.
    - payload: The packet payload.
  """
  @spec encode(integer(), integer(), integer(), integer(), bitstring()) :: <<_::_ * 7>>
  def encode(type, connection_id, packet_number, version, payload) do
    <<1::1, type::7, connection_id::64, packet_number::32, version::32>> <> payload
  end
end

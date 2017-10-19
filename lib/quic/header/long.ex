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
end

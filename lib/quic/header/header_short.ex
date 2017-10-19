defmodule QUIC.Header.Short do
  @moduledoc """
  The short header can be used after the version and 1-RTT keys are negotiated.

  ```
   0                   1                   2                   3
   0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
  +-+-+-+-+-+-+-+-+
  |0|C|K| Type (5)|
  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  |                                                               |
  +                     [Connection ID (64)]                      +
  |                                                               |
  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  |                      Packet Number (8/16/32)                ...
  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  |                     Protected Payload (*)                   ...
  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  ```

  [Source](https://quicwg.github.io/base-drafts/draft-ietf-quic-transport.html#short-header)
  """

  @typedoc """
  c: Connection id flag. The second bit (0x40) of the first octet
  indicates whether the Connection id field is present.
  k: Key phase. This allows a recipient of a packet to identify the
  packet protection keys that are used to protect the packet.
  type: A bitmask indicating types for a packet.
  connection_id: The 64 bit id for the connection.
  packet_number: The 64 bit unsigned packet number, which is
  used as a part of a cryptographic nonce for packet encryption.
  payload: The 1-RTT packet payload.
  """
  @type t :: %__MODULE__{
    c: integer,
    k: integer,
    type: integer,
    connection_id: integer,
    packet_number: integer,
    payload: bitstring
  }

  @enforce_keys [:c, :k, :type, :packet_number, :payload]
  defstruct [:c, :k, :type, :connection_id, :packet_number, :payload]
end

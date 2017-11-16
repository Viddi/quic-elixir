defmodule QUIC.Packet do
  @moduledoc """
  This module is used as a facade that delegates to the proper
  functions. This is only a convenience module that allows for
  better naming and calling order for each function used to
  encode, or decode a packet.
  """

  ## Header dispatches

  defdelegate header(type, connection_id, packet_number, version, payload),
    to: QUIC.Header.Long, as: :encode

  ## Packet dispatches

  defdelegate version_negotiation(),
    to: QUIC.Packet.VersionNegotiation, as: :encode
end

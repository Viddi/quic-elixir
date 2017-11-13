defmodule QUIC.Packet do
  @moduledoc """
  TODO
  """

  ## Header dispatches

  defdelegate header(type, connection_id, packet_number, version, payload),
    to: QUIC.Header.Long, as: :encode

  ## Packet dispatches

  defdelegate version_negotiation(),
    to: QUIC.Packet.VersionNegotiation, as: :encode
end

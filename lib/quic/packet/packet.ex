defmodule QUIC.Packet do
  @moduledoc """
  TODO
  """

  alias QUIC.Packet.VersionNegotiation

  defdelegate version_negotiation(), to: VersionNegotiation, as: :encode
end

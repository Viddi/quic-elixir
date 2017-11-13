defprotocol QUIC.Type do
  @moduledoc """
  Various extension functions for Bitstring since the QUIC
  library deals with bitstrings structure a lot.
  """

  @fallback_to_any true

  @doc """
  Checks the type of the Packet for the given bitstring.
  """
  @spec packet_type(bitstring) :: {:long, integer} | {:short, integer} | {:error, String.t}
  def packet_type(bitstring)
end

defimpl QUIC.Type, for: Bitstring do

  alias QUIC.Header.Long
  alias QUIC.Header.Short

  ## QUIC.Header.Long.Type

  def packet_type(<<1::1, 1::7, _::bitstring>>), do: {:long, Long.Type.version_negotiation()}

  def packet_type(<<1::1, 2::7, _::bitstring>>), do: {:long, Long.Type.client_initial()}

  def packet_type(<<1::1, 3::7, _::bitstring>>), do: {:long, Long.Type.server_stateless_retry()}

  def packet_type(<<1::1, 4::7, _::bitstring>>), do: {:long, Long.Type.server_cleartext()}

  def packet_type(<<1::1, 5::7, _::bitstring>>), do: {:long, Long.Type.client_cleartext()}

  def packet_type(<<1::1, 6::7, _::bitstring>>), do: {:long, Long.Type.zero_rtt_protected()}

  ## QUIC.Header.Short.Type

  def packet_type(<<0::1, _::1, _::1, 1::7, _::bitstring>>), do: {:short, Short.Type.one_octet()}

  def packet_type(<<0::1, _::1, _::1, 2::7, _::bitstring>>), do: {:short, Short.Type.two_octet()}

  def packet_type(<<0::1, _::1, _::1, 3::7, _::bitstring>>), do: {:short, Short.Type.four_octet()}
end

defimpl QUIC.Type, for: Any do

  ## TODO: Return a real error

  def packet_type(_), do: {:error, "No match for packet type"}
end

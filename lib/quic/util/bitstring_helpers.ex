defprotocol QUIC.Type do
  @moduledoc """
  Various extension functions for Bitstring since the QUIC
  library deals with bitstrings structure a lot.
  """

  @doc """
  Checks the type of the Packet for the given bitstring.
  """
  @spec packet_type(bitstring) :: atom
  def packet_type(bitstring)
end

defimpl QUIC.Type, for: Bitstring do

  ## TODO: Reuse QUIC.Header Types

  ## QUIC.Header.Long.Type

  def packet_type(<<1::1, 1::7, _::bitstring>>), do: :version_negotiation

  def packet_type(<<1::1, 2::7, _::bitstring>>), do: :client_initial

  def packet_type(<<1::1, 3::7, _::bitstring>>), do: :server_stateless_retry

  def packet_type(<<1::1, 4::7, _::bitstring>>), do: :server_cleartext

  def packet_type(<<1::1, 5::7, _::bitstring>>), do: :client_cleartext

  def packet_type(<<1::1, 6::7, _::bitstring>>), do: :zero_rtt_protected

  ## QUIC.Header.Short.Type

  def packet_type(<<0::1, _::1, _::1, 1::7, _::bitstring>>), do: :one_octed

  def packet_type(<<0::1, _::1, _::1, 2::7, _::bitstring>>), do: :two_octed

  def packet_type(<<0::1, _::1, _::1, 3::7, _::bitstring>>), do: :three_octed

  ## Default case

  def packet_type(_), do: :todo_error
end

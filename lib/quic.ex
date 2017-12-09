defmodule QUIC do
  @moduledoc """
  Documentation for QUIC.
  """

  @doc """
  A list of all supported QUIC versions.

  ## Examples

    iex> QUIC.supported_versions()
    [40]
  """
  @spec supported_versions() :: [40, ...]
  def supported_versions(), do: [40]

  ## Socket API

  @spec open(integer, list, list) :: pid
  def open(port, udp_opts, opts) do
    args = [
      port: port,
      udp_opts: udp_opts
    ]

    QUIC.Connection.start(args, opts)
  end

  def open_link(port, udp_opts, opts) do
    args = [
      port: port,
      udp_opts: udp_opts
    ]

    QUIC.Connection.start_link(args, opts)
  end
end

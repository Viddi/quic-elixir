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

  @spec start() :: GenServer.on_start
  @spec start(GenServer.options) :: GenServer.on_start
  def start(opts \\ []) do
    QUIC.Connection.start(opts)
  end

  @spec start_link() :: GenServer.on_start
  @spec start_link(GenServer.options) :: GenServer.on_start
  def start_link(opts \\ []) do
    QUIC.Connection.start_link(opts)
  end

  # def listen(port, opts), do: QUIC.Connection.

  def close(pid) do
    QUIC.Connection.close(pid)
  end
end

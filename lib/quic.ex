defmodule QUIC do
  @moduledoc """
  Documentation for QUIC.
  """

  @doc """
  A list of all supported QUIC versions.
  """
  @spec supported_versions() :: [40, ...]
  def supported_versions(), do: [40]
end

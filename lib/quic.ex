defmodule QUIC do
  @moduledoc """
  Documentation for QUIC.
  """

  @doc """
  A list of all supported QUIC versions.
  """
  @spec supported_versions() :: [integer]
  def supported_versions(), do: [40]
end

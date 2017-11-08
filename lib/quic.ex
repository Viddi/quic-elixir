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
end

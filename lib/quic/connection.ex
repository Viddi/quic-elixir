defmodule QUIC.Connection do
  @moduledoc """
  A GenServer process for a single QUIC connection.
  """

  use GenServer

  require Logger

  @gen_udp_opts [
    :binary,
    active: 10,
    add_membership: {{127, 0, 0, 1}, {0, 0, 0, 0}},
    multicast_if: {0, 0, 0, 0}
  ]

  @typedoc """
  The data that needs to be stored during
  the lifecycle of a QUIC connection.

  socket: reference to the gen_udp socket.
  """
  @type t :: %__MODULE__{
    socket: port
  }

  defstruct [:socket]

  @doc false
  def init(args) do
    case open_socket(args) do
      {:ok, socket} ->
        {:ok, %__MODULE__{socket: socket}}
      {:error, reason} ->
        {:stop, reason}
    end
  end

  @doc """
  Overrides GenServer start/3 function.

  ## Parameters

    - args: A keyword list [port: 1234, udp_opts: [:binary]]
    - opts: Options list passed to GenServer start/3 function.
  """
  @spec start(list) :: {:error, term} | {:ok, pid}
  @spec start(list, list) :: {:error, term} | {:ok, pid}
  def start(args, opts \\ []) do
    GenServer.start(__MODULE__, args, opts)
  end

  @doc """
  Overrides GenServer start_link/3 function.

  ## Parameters

    - args: A keyword list [port: 1234, udp_opts: [:binary]]
    - opts: Options list passed to GenServer start_link/3 function.
  """
  @spec start_link(list) :: {:error, term} | {:ok, pid}
  @spec start_link(list, list) :: {:error, term} | {:ok, pid}
  def start_link(args, opts \\ []) do
    GenServer.start_link(__MODULE__, args, opts)
  end

  @doc """
  Closes the QUIC connection for the given pid.

  ## Parameters

    - pid: The pid for the QUIC.Connection process.
  """
  @spec close(pid) :: tuple
  def close(pid) when is_pid(pid) do
    Logger.info("Closing connection with pid: #{inspect(pid)}")
    GenServer.call(pid, :close)
  end

  ## GenServer callbacks

  @doc false
  def handle_info({:udp, _socket, ip, port, packet}, state) do
    Logger.info("Received udp packet: #{inspect(packet)} from #{inspect(ip)}:#{inspect(port)}")
    {:noreply, state}
  end

  @doc false
  def handle_call(:close, _from, state) do
    {:stop, :normal, :ok, state}
  end

  @doc false
  def terminate(_reason, state) do
    :gen_udp.close(state.socket)
    :ok
  end

  ## Private functions

  # Opens a socket with the given options (opts[:udp_opts]),
  # or the default udp options provided by this module.
  @spec open_socket(list) :: tuple
  defp open_socket(opts) do
    :gen_udp.open(opts[:port], if opts[:udp_opts] do opts[:udp_opts] else @gen_udp_opts end)
  end
end

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

  @type on_start :: {:ok, pid} | :ignore | {:error, {:already_started, pid} | term}

  defstruct [:socket]

  @doc false
  def init(_args) do
    {:ok, %__MODULE__{}}
  end

  @doc """
  Overrides GenServer start/3 function.

  ## Parameters

    - opts: Options list passed to GenServer start/3 function.
  """
  @spec start() :: GenServer.on_start
  @spec start(GenServer.options) :: GenServer.on_start
  def start(opts \\ []) do
    GenServer.start(__MODULE__, [], opts)
  end

  @doc """
  Overrides GenServer start_link/3 function.

  ## Parameters

    - opts: Options list passed to GenServer start_link/3 function.
  """
  @spec start_link() :: GenServer.on_start
  @spec start_link(GenServer.options) :: GenServer.on_start
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  @doc """
  Opens the UDP socket on the given port. If successful,
  the port returned from this function should be passed into
  the accept/1 or accept/2 function.

  ## Parameters

    - port: The port which the socket will be created on.
    - opts: A list of options that will be passed to the udp socket.
  """
  @spec listen(pid, integer) :: {:ok, port} | {:error, atom}
  @spec listen(pid, integer, Keyword.t) :: {:ok, port} | {:error, atom}
  def listen(pid, port, opts \\ []) do
    open_socket(port, opts)
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
  def handle_call({:listen, port, opts}, _from, state) do
    {:reply, :ok, state}
  end

  @doc false
  def handle_call(:close, _from, state) do
    {:stop, :normal, :ok, state}
  end

  @doc false
  def handle_info({:udp, _socket, ip, port, packet}, state) do
    Logger.info("Received udp packet: #{inspect(packet)} from #{inspect(ip)}:#{inspect(port)}")
    {:noreply, state}
  end

  @doc false
  def terminate(_reason, state) do
    :gen_udp.close(state.socket)
    :ok
  end

  ## Private functions

  # Opens a socket with the given options (opts[:udp_opts]),
  # or the default udp options provided by this module.
  @spec open_socket(port, Keyword.t) :: {:ok, port} | {:error, atom}
  defp open_socket(port, opts) do
    :gen_udp.open(port, if opts[:udp_opts] do opts[:udp_opts] else @gen_udp_opts end)
  end
end

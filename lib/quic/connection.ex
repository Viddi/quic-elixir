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
  Opens the UDP socket on the given port.

  ## Parameters

    - pid: The process identifier for the connection.
    - port: The port which the socket will be created on.
    - opts: A list of options that will be passed to the udp socket.
  """
  @spec open(pid, integer) :: term
  @spec open(pid, integer, [any]) :: term
  def open(pid, port, opts \\ []) do
    GenServer.call(pid, {:open, port, opts})
  end

  @doc """
  Only being used for testing now.

  ## Parameters

    - pid: The process identifier for the connection.
    - address: The recipient ip address.
    - port: The port of the socket.
    - payload: The payload to send.
  """
  @spec send(pid, {integer, integer, integer, integer}, integer, term) :: :ok
  def send(pid, address, port, payload) do
    GenServer.cast(pid, {:send, address, port, payload})
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
  def handle_call({:open, port, opts}, _from, state) do
    case open_socket(port, opts) do
      {:ok, socket} ->
        {:reply, {:ok, socket}, %{state | socket: socket}}
      {:error, reason} ->
        {:reply, {:error, reason}, state}
    end
  end

  @doc false
  def handle_call(:close, _from, state) do
    {:stop, :normal, :ok, state}
  end

  @doc false
  def handle_cast({:send, address, port, packet}, _from, state) do
    if state.socket do
      :gen_udp.send(state.socket, address, port, packet)
    end
    {:noreply, state}
  end

  @doc false
  def handle_info({:udp, _socket, ip, port, packet}, state) do
    Logger.info("Received udp packet: #{inspect(packet)} from #{inspect(ip)}:#{inspect(port)}")
    {:noreply, state}
  end

  @doc false
  def terminate(reason, state) do
    Logger.info("Closing connection: #{inspect(reason)}")
    if state.socket do
      :gen_udp.close(state.socket)
    end
    :ok
  end

  ## Private functions

  # Opens a socket with the given options (opts[:udp_opts]),
  # or the default udp options provided by this module.
  @spec open_socket(integer, [any]) :: {:error, atom} | {:ok, port}
  defp open_socket(port, opts) do
    :gen_udp.open(port, if List.first(opts) do opts else @gen_udp_opts end)
  end
end

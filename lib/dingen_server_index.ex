defmodule Dingen.ServerIndex do
  use GenServer
  require Logger

  def start_link(options) do
    %{name: name} = options
    GenServer.start_link(__MODULE__, options, [name: name])
  end

  def init(options) do
    GenServer.cast(self(), :start_webserver)
    state = %{options: options}
    {:ok, state}
  end

  def handle_cast(:start_webserver, state) do
    %{options: %{name: name, port: port}} = state
    routes = [
      {:_, [
          {"/", Dingen.Handler.ServerIndex, []},
      ]}
    ]
    dispatch = :cowboy_router.compile(routes)
    proto_opts = [env: [dispatch: dispatch]]
    trans_opts = [port: port]
    acceptors = 100

    cowboy_result = :cowboy.start_http(name, acceptors, trans_opts, proto_opts)

    case cowboy_result do
      {:ok, _pid} -> :ok
      {:error, {:already_started, _pid}} -> :ok
    end

    {:noreply, state}
  end
end

defmodule Dingen.Server do
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
    # Collect webserver configuration.
    %{name: name, port: port, protocol: protocol} = state[:options]
    routes = [
      {:_, [
          {"/", Dingen.Handler, []}
      ]}
    ]
    dispatch = :cowboy_router.compile(routes)
    proto_opts = [env: [dispatch: dispatch]]
    trans_opts = [port: port]
    acceptors = 100

    # Start the correct cowboy listener based on the configured protocol.
    cowboy_result = case protocol do
      :HTTP ->
        :cowboy.start_http(name, acceptors, trans_opts, proto_opts)
      :HTTPS ->
        priv_dir = :code.priv_dir(:dingen)
        trans_opts = trans_opts ++ [
          certfile: priv_dir ++ '/certs/server.crt',
          keyfile: priv_dir ++ '/certs/server.key'
        ]
        :cowboy.start_https(name, acceptors, trans_opts, proto_opts)
    end

    # Check if things went well (initially as well as on gen server restart.
    case cowboy_result do
      {:ok, _pid} -> :ok
      {:error, {:already_started, _pid}} -> :ok
    end

    {:noreply, state}

    # Restarting cowboy
    # =================
    # Restarting can of course be done by stopping and starting the listeners
    # again.
    #
    # Rather than stopping and starting the cowboy listener unconditionally, it
    # would probably be better to check if that is actually needed. The check
    # could involve the following steps:
    #
    # * check if there is a matching ranch listener already with the given name
    # * get the listener's child specification specification
    # * compare the child specification with the currently needed configuration
    #
    # And in case there is no ranch listener we would start one, in case there
    # is one but the spec does not match we stop it and start a new one with
    # the correct spec and otherwise we leave it as is.
    #
    #
    # Stop and start
    # --------------
    # :cowboy.stop_listener(name)
    # {:ok, _pid} = :cowboy.start_http(name, acceptors, trans_opts, proto_opts)
    #
    # .. with condition on protocol
    # :cowboy.stop_listener(name)
    # case protocol do
    #   :HTTP ->
    #     {:ok, _pid} = :cowboy.start_http(name, acceptors, trans_opts, proto_opts)
    #   :HTTPS ->
    #     {:ok, _pid} = :cowboy.start_https(name, acceptors, trans_opts, proto_opts)
    # end
    #
    #
    # Check for supervisor child using ranch and start
    # ------------------------------------------------
    # case :supervisor.get_childspec(:ranch_sup, {:ranch_listener_sup, name}) do
    #   {:error, :not_found} ->
    #     opts = [port: port]
    #     env = [dispatch: dispatch]
    #     {:ok, _pid} = :cowboy.start_http(name, 100, opts, env)
    #   {:ok, childspec} ->
    #     # check childspec
    #     # in case it is not right stop and start a new one
    #     :ok
    # end
  end
end

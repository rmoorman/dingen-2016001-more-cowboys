defmodule Dingen do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    # Starts a worker by calling: Dingen.Worker.start_link(arg1, arg2, arg3)
    # worker(Dingen.Worker, [arg1, arg2, arg3]),
    children = [
      # Random string dispenser
      worker(:dingen_dispenser, [], [id: :dingen_dispenser]),

      # Main index page
      worker(
        Dingen.ServerIndex,
        [%{name: Dingen.ServerIndex, port: 8000}],
        [id: Dingen.ServerIndex]
      ),

      # Elixir HTTP
      worker(
        Dingen.Server,
        [%{name: Dingen.ElixirHTTP1, port: 8001, protocol: :HTTP}],
        [id: Dingen.ElixirHTTP1]
      ),
      worker(
        Dingen.Server,
        [%{name: Dingen.ElixirHTTP2, port: 8002, protocol: :HTTP}],
        [id: Dingen.ElixirHTTP2]
      ),

      # Elixir HTTPS
      worker(
        Dingen.Server,
        [%{name: Dingen.ElixirHTTPS1, port: 8003, protocol: :HTTPS}],
        [id: Dingen.ElixirHTTPS1]
      ),
      worker(
        Dingen.Server,
        [%{name: Dingen.ElixirHTTPS2, port: 8004, protocol: :HTTPS}],
        [id: Dingen.ElixirHTTPS2]
      ),

      # Erlang HTTP
      worker(
        :dingen_server,
        [%{:name => Dingen.ErlangHTTP1, :port => 8005, :protocol => :HTTP}],
        [id: Dingen.ErlangHTTP1]
      ),
      worker(
        :dingen_server,
        [%{:name => Dingen.ErlangHTTP2, :port => 8006, :protocol => :HTTP}],
        [id: Dingen.ErlangHTTP2]
      ),

      # Erlang HTTPS
      worker(
        :dingen_server,
        [%{:name => Dingen.ErlangHTTPS1, :port => 8007, :protocol => :HTTPS}],
        [id: Dingen.ErlangHTTPS1]
      ),
      worker(
        :dingen_server,
        [%{:name => Dingen.ErlangHTTPS2, :port => 8008, :protocol => :HTTPS}],
        [id: Dingen.ErlangHTTPS2]
      ),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dingen.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule Dingen do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Dingen.Worker.start_link(arg1, arg2, arg3)
      # worker(Dingen.Worker, [arg1, arg2, arg3]),
      worker(:dingen_dispenser, []),
      worker(
        Dingen.Server,
        [%{name: Dingen.ElixirHTTP, port: 8000, protocol: :HTTP}],
        [id: Dingen.ElixirHTTP]
      ),
      worker(
        Dingen.Server,
        [%{name: Dingen.ElixirHTTPS, port: 8001, protocol: :HTTPS}],
        [id: Dingen.ElixirHTTPS]
      ),
      #      worker(
      #        :dingen_server,
      #        [%{:name => Dingen.ErlangHTTP, :port => 8002, :protocol => :HTTP}],
      #        [id: Dingen.ErlangHTTP]
      #      ),
      #      worker(
      #        :dingen_server,
      #        [%{:name => Dingen.ErlangHTTPS, :port => 8003, :protocol => :HTTPS}],
      #        [id: Dingen.ErlangHTTPS]
      #      ),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dingen.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule Dingen.Handler.ServerIndex do
  def init(_type, req, _opts) do
    {:ok, req, :no_state}
  end

  def handle(req, state) do
    headers = [{"content-type", "text/html"}]
    servers = [
      {"http://localhost:8001", "elixir http"},
      {"http://localhost:8002", "elixir http"},
      {"https://localhost:8003", "elixir https"},
      {"https://localhost:8004", "elixir https"},
      {"http://localhost:8005", "erlang http"},
      {"http://localhost:8006", "erlang http"},
      {"https://localhost:8007", "erlang https"},
      {"https://localhost:8008", "erlang https"},
    ]
    body = ["<title>Index</title>"] ++
      for {url, title} <- servers, do: "<a href='#{url}'>#{title}</a><br>"

    {:ok, req} = :cowboy_req.reply(200, headers, body, req)
    {:ok, req, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end

defmodule Dingen.Handler.Random do
  def init(_type, req, _opts) do
    {:ok, req, :no_state}
  end

  def handle(req, state) do
    headers = [{"content-type", "text/html"}]
    random = GenServer.call(:dingen_dispenser, :random)
    body = "
      <title>Hello #{random}!</title>
      <p>Hello #{random}!</p>
    "
    {:ok, req} = :cowboy_req.reply(200, headers, body, req)
    {:ok, req, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end

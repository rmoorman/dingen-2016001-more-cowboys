defmodule Dingen.Handler.World do
  def init(_type, req, _opts) do
    {:ok, req, :no_state}
  end

  def handle(req, state) do
    headers = [{"content-type", "text/html"}]
    body = "
      <title>Hello world!</title>
      <p>Hello world!</p>
    "
    {:ok, req} = :cowboy_req.reply(200, headers, body, req)
    {:ok, req, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end

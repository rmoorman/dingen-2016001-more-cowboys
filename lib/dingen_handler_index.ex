defmodule Dingen.Handler.Index do
  def init(_type, req, _opts) do
    {:ok, req, :no_state}
  end

  def handle(req, state) do
    headers = [{"content-type", "text/html"}]
    body = "
      <title>Index</title>
      <a href=/hello-world/>hello world</a>
      <br>
      <a href=/hello-random/>hello random</a>
    "
    {:ok, req} = :cowboy_req.reply(200, headers, body, req)
    {:ok, req, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end

defmodule Dingen.Handler do
  def init(_type, req, opts) do
    {:ok, req, :no_state}
  end

  def handle(req, state) do
    headers = [{"content-type", "text/plain"}]
    body = "Hello world"
    {:ok, req} = :cowboy_req.reply(200, headers, body, req)
    {:ok, req, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end

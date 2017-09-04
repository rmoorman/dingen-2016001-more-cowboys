-module(dingen_handler_index).

-export([init/3, handle/2, terminate/3]).



init(_Type, Req, _Opts) ->
  {ok, Req, no_state}.


handle(Req, State) ->
  Headers = [{"content-type", "text/html"}],
  Body = "
    <title>Index</title>
    <a href=/hello-world/>hello world</a>
    <br>
    <a href=/hello-random/>hello random</a>
  ",
  {ok, Req2} = cowboy_req:reply(200, Headers, Body, Req),
  {ok, Req2, State}.


terminate(_Reason, _Req, _State) ->
  ok.

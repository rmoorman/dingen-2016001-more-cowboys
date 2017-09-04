-module(dingen_handler_random).

-export([init/3, handle/2, terminate/3]).



init(_Type, Req, _Opts) ->
  {ok, Req, no_state}.


handle(Req, State) ->
  Headers = [{"content-type", "text/html"}],
  Random = gen_server:call(dingen_dispenser, random),
  Body = [
    "<title>Hello ", Random, "!</title>",
    "<p>Hello ", Random, "!</p>"
  ],
  {ok, Req2} = cowboy_req:reply(200, Headers, Body, Req),
  {ok, Req2, State}.


terminate(_Reason, _Req, _State) ->
  ok.

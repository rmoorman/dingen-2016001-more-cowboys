-module(dingen_server).

-behaviour(gen_server).

-export([start_link/2]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).



%%% external api
start_link(Name, Options) ->
  gen_server:start_link(
    {local, Name}, % register the gen_server locally with the name of this module
    ?MODULE, % the callback module (which is obviously this module)
    Options, % arguments to pass to init/1
    [] % options for the gen server
  ).



%%% gen_server callbacks
init(_Args) ->
  {ok, undefined}.

handle_call(_, _From, State) -> {noreply, State}.
handle_cast(_, State) -> {noreply, State}.
handle_info(_, State) -> {noreply, State}.
terminate(_, _State) -> ok.
code_change(_, State, _) -> {ok, State}.

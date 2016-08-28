-module(dingen_dispenser).

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).



%%% external api
start_link() ->
  gen_server:start_link(
    {local, ?MODULE}, % register the gen_server locally with the name of this module
    ?MODULE, % the callback module (which is obviously this module)
    [], % arguments to pass to init/1
    [] % options for the gen server
  ).



%%% gen_server callbacks
init(_Args) -> {ok, undefined}.

handle_call(_, _From, State) ->
  Reply = some_random_thing(),
  {reply, Reply, State}.

handle_cast(_, State) -> {noreply, State}.
handle_info(_, State) -> {noreply, State}.
terminate(_, _State) -> ok.
code_change(_, State, _) -> {ok, State}.



%%% Internals
some_random_thing() ->
  List = [
    "amigo", "banjo", "beach", "beard", "boxes",
    "chips", "click", "clown", "goose", "power",
    "sushi", "teeth", "watch", "world", "wurst"
  ],
  RandomIndex = rand:uniform(length(List)),
  lists:nth(RandomIndex, List).

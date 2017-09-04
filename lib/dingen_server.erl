-module(dingen_server).

-behaviour(gen_server).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).



%%% external api
start_link(Options) ->
  #{name := Name} = Options,
  gen_server:start_link(
    {local, Name}, % register the gen_server locally with the name of this module
    ?MODULE, % the callback module (which is obviously this module)
    Options, % arguments to pass to init/1
    [] % options for the gen server
  ).



%%% gen_server callbacks
init(Options) ->
  gen_server:cast(self(), start_webserver),
  State = #{options => Options},
  {ok, State}.


handle_call(_, _From, State) ->
  {noreply, State}.


handle_cast(start_webserver, State) ->
  % Collect webserver configuration.
  #{options := #{name := Name, port := Port, protocol := Protocol}} = State,
  Routes = [
    {'_', [
      {"/", dingen_handler_index, []},
      {"/hello-world/", dingen_handler_world, []},
      {"/hello-random/", dingen_handler_random, []}
    ]}
  ],
  Dispatch = cowboy_router:compile(Routes),
  ProtoOpts = [{env, [{dispatch, Dispatch}]}],
  TransOpts = [{port, Port}],
  Acceptors = 100,

  % Start the correct cowboy listener based on the configured protocol
  CowboyResult = case Protocol of
    'HTTP' ->
      cowboy:start_http(Name, Acceptors, TransOpts, ProtoOpts);
    'HTTPS' ->
      PrivDir = code:priv_dir(dingen),
      TransOpts2 = TransOpts ++ [
        {certfile, PrivDir ++ "/certs/server.crt"},
        {keyfile, PrivDir ++ "/certs/server.key"}
      ],
      cowboy:start_https(Name, Acceptors, TransOpts2, ProtoOpts)
  end,

  % Check if things went well (initially as well as on gen server restart).
  case CowboyResult of
    {ok, _CowboyPid} -> ok;
    {error, {already_started, _CowboyPid}} -> ok
  end,
  {noreply, State};

handle_cast(_, State) ->
  {noreply, State}.


handle_info(_, State) ->
  {noreply, State}.


terminate(_, _State) ->
  ok.


code_change(_, State, _) ->
  {ok, State}.

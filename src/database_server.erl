%%%-------------------------------------------------------------------
%%% @author Kanishka Bandara
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(database_server).

-behaviour(gen_server).

-export([start_link/1, store/4, getalldb/1, delete/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

-record(database_server_state, {}).

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

start_link(Nodes) ->
  gen_server:start_link({local,?MODULE}, ?MODULE, Nodes, []).



init(Nodes) ->
  process_flag(trap_exit, true),
  io:format("~p (~p) starting...~n", [{local, ?MODULE}, self()]),
  database_logic:install(Nodes),
  {ok, #database_server_state{}}.

store(Node, Username, Location, Gender) ->
  gen_server:call({database_server,'john@DESKTOP-RD414DV'}, {store_db, Node, Username, Location, Gender}).

%%getdb(Node) ->
%%  gen_server:call({local, ?MODULE}, {get_db, Node}).

%%Node arg should be string("nmn@...")
getalldb(Node) ->
  gen_server:call({database_server,'john@DESKTOP-RD414DV'}, {get_all_db, Node}).
delete(Node) ->
  gen_server:call({database_server,'john@DESKTOP-RD414DV'}, {delete, Node}).

handle_call({store_db, Node, Username, Location, Gender}, _From, State = #database_server_state{}) ->
  database_logic:store_db(Node, Username, Location, Gender),
  N = Node ++" User details are saved!",
  {reply, {ok, N}, State};

%%handle_call({get_db, Node}, _From, State = #database_server_state{}) ->
%%  X = database_logic:get_db(Node),
%%  {_, [Name]} = X,
%%  io:format("SENDER NAME: ~p~n", [Name]),
%%  {reply, ok, State};

handle_call({get_all_db, Node}, _From, State = #database_server_state{}) ->
  Y = database_logic:get_all_dbe(Node),
  {_, [{Name, Location, Gender}]} = Y,
  Z ="SENDER NAME: "++Name++" LOCATION: "++Location++" GENDER: "++Gender,
  {reply, {ok, Z}, State};

handle_call({delete, Node},  _From, State = #database_server_state{}) ->
  database_logic:delete_db(Node),
  M ="Node: " ++Node++ "data deleted!",
  {reply, {ok, M}, State}.

handle_cast(_Request, State = #database_server_state{}) ->
  {noreply, State}.

handle_info(_Info, State = #database_server_state{}) ->
  {noreply, State}.

terminate(_Reason, _State = #database_server_state{}) ->
  ok.

code_change(_OldVsn, State = #database_server_state{}, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

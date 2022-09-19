%%%-------------------------------------------------------------------
%%% @author Kanishka Bandara
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(chat_app).

-behaviour(application).

-export([start/2, stop/1, stop/0, start/0]).

start() ->
  application:start(?MODULE).

start(_StartType, _StartArgs) ->
  db_sup:start_link().

stop() ->
  mnesia:stop(),
  application:stop(?MODULE).

stop(_State) ->
  ok.

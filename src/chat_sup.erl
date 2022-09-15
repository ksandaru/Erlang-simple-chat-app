%%%-------------------------------------------------------------------
%%% @author Kanishka Bandara
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(chat_sup).

-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  io:format("~p / ~p starting superviser...~n", [{global, ?MODULE}, self()]),
  AChild = #{id => message_server,
    start => {message_server, start_link, []},
    restart => permanent,
    shutdown => 5000,
    type => worker,
    modules => [message_server]},

  {ok, {#{strategy => one_for_one,
    intensity => 5,
    period => 30},
    [AChild]}
  },
  BChild = #{id => database_server,
    start => {database_server, start_link, []},
    restart => permanent,
    shutdown => 2000,
    type => worker,
    modules => [database_server]},

  {ok, {#{strategy => one_for_one,
    intensity => 5,
    period => 30},
    [BChild]}
  }.

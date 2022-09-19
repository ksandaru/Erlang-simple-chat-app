%%%-------------------------------------------------------------------
%%% @author Kanishka Bandara
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(db_sup).

-behaviour(supervisor).

-export([start_link/0, init/1, start_link_shell/0]).

start_link_shell()->
  {ok, Pid}= supervisor:start_link({global,?MODULE}, ?MODULE,[]),
  unlink(Pid).

start_link() ->
  supervisor:start_link({global, ?MODULE}, ?MODULE, []).

init([]) ->
  io:format("~p / ~p starting database superviser...~n", [{global, ?MODULE}, self()]),
  AChild = #{id => 'database_server',
    start => {'database_server', start_link, []},
    restart => permanent,
    shutdown => infinity,
    type => worker,
    modules => ['database_server']},

  {ok, {#{strategy => one_for_all,
    intensity => 5,
    period => 30},
    [AChild]}
  }.

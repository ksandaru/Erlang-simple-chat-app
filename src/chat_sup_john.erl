%%%-------------------------------------------------------------------
%%% @author Kanishka Bandara
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(chat_sup_john).

-behaviour(supervisor).

-export([start_link/0, init/1, start_link_shell_john/0]).

start_link_shell_john()->
  {ok, Pid}= supervisor:start_link({local,?MODULE}, ?MODULE,[]),
  unlink(Pid).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  AChild = #{id => 'message_server1',
    start => {'message_server', start_link, ['john']},
    restart => permanent,
    shutdown => infinity,
    type => worker,
    modules => ['message_server']},

  {ok, {#{strategy => one_for_one,
    intensity => 5,
    period => 30},
    [AChild]}
  }.

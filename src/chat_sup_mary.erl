%%%-------------------------------------------------------------------
%%% @author Kanishka Bandara
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(chat_sup_mary).

-behaviour(supervisor).

-export([start_link/0, init/1, start_link_shell_mary/0]).

start_link_shell_mary()->
  {ok, Pid}= supervisor:start_link({local,?MODULE}, ?MODULE,[]),
  unlink(Pid).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  BChild = #{id => 'message_server2',
    start => {'message_server', start_link, ['mary']},
    restart => permanent,
    shutdown => infinity,
    type => worker,
    modules => ['message_server']},

  {ok, {#{strategy => one_for_one,
    intensity => 5,
    period => 30},
    [BChild]}
  }.
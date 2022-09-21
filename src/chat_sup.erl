%%%-------------------------------------------------------------------
%%% @author Kanishka Bandara
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(chat_sup).

-behaviour(supervisor).

-export([start_link/0, init/1, start_link_shell2/0]).

start_link_shell2()->
  {ok, Pid2}= supervisor:start_link({global,?MODULE}, ?MODULE,[]),
  unlink(Pid2).

start_link() ->
  supervisor:start_link({global, ?MODULE}, ?MODULE, []).

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
  },
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
  },
  CChild = #{id => 'message_server3',
    start => {'message_server', start_link, ['clark']},
    restart => permanent,
    shutdown => infinity,
    type => worker,
    modules => ['message_server']},

  {ok, {#{strategy => one_for_one,
    intensity => 5,
    period => 30},
    [CChild]}
  }.

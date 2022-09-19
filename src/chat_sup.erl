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
  {ok, Pid}= supervisor:start_link({global,?MODULE}, ?MODULE,[]),
  unlink(Pid).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  AChild = #{id => 'message_server',
    start => {'message_server', start_link, []},
    restart => permanent,
    shutdown => infinity,
    type => worker,
    modules => ['message_server']},

  {ok, {#{strategy => one_for_all,
    intensity => 5,
    period => 30},
    [AChild]}
  }.

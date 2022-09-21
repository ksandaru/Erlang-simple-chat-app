%%%-------------------------------------------------------------------
%%% @author Kanishka Bandara
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(chat_sup_clark).

-behaviour(supervisor).

-export([start_link/0, init/1, start_link_shell_clark/0]).

start_link_shell_clark()->
  {ok, Pid}= supervisor:start_link({local,?MODULE}, ?MODULE,[]),
  unlink(Pid).

start_link() ->
  supervisor:start_link({local, 'clark@DESKTOP-RD414DV'}, ?MODULE, []).

init([]) ->
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
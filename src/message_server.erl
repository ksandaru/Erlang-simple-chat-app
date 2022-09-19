%%%-------------------------------------------------------------------
%%% @author Kanishka Bandara
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Sep 2022 12:35 PM
%%%-------------------------------------------------------------------

-module(message_server).

-behaviour(gen_server).

-export([send_message/2, receive_message/3, start_link/1, stop/0, recv_msg/1, readyto_send/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

-record(message_server_state, {from, to, msgsent, msgreceived}).

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================
start_link(Name) ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, Name, []).

init(Name) ->
  io:format("~p is connected with the server...~n", [Name]),
  {ok, #message_server_state{
    from = atom_to_list(node()),
    to = [],
    msgsent = [],
    msgreceived = []
  }}.
stop() ->
  gen_server:stop(?MODULE).

%%here Sender argument should be string("clark@....")
%%receive_db_data(Sender) ->
%%  database_server:getalldb(Sender).

%%receive_db_data(Sender) ->
%%  gen_server:call({database_server,'john@DESKTOP-RD414DV'},{rec_data, Sender}).


send_message(To, Msg) ->
  gen_server:call({?MODULE, node()}, {send, To, Msg}).

receive_message(Sender, To, Msg) ->
  gen_server:call({?MODULE, list_to_atom(To)}, {reciv, Sender, Msg}).

recv_msg(Msg)->
  gen_server:call({?MODULE, node()}, {recive, Msg}).

readyto_send(To)->
  gen_server:call({?MODULE, list_to_atom(To)}, {ready, To}).

handle_call({send, To, Msg}, _From, State = #message_server_state{to = Receivers, msgsent = Msgsent, from = Sender}) ->
  io:format("Sent message: ~p~n", [Msg]),
%%  chat_fsm:message_send(Msg, To),
  receive_message(Sender, To, Msg),
  {reply, ok, State#message_server_state{msgsent = [Msg | Msgsent], to = [To | Receivers]}};


handle_call({reciv, Sender, Msg}, _From, State = #message_server_state{msgreceived = Msgreceived}) ->
  io:format("Sent by: ~p~n", [Sender]),
  io:format("Message: ~p~n", [Msg]),
  M = database_server:getalldb(Sender),
  io:format("SENDER-DETAILS>>: ~p~n",[M]),
  {reply, ok, State#message_server_state{msgreceived = [Msg | Msgreceived]}};

handle_call({recive, Msg}, _From, State = #message_server_state{msgreceived = Msgreceived}) ->
  io:format("Message: ~p~n", [Msg]),
  {reply, ok, State#message_server_state{msgreceived = [Msg | Msgreceived]}};

handle_call({ready, To}, _From, State) ->
%%  chat_fsm:ready_to_send(To),
  {reply, ok, State}.

handle_cast(_Request, State = #message_server_state{}) ->
  {noreply, State}.

handle_info(_Info, State = #message_server_state{}) ->
  {noreply, State}.

terminate(_Reason, _State = #message_server_state{}) ->
  ok.

code_change(_OldVsn, State = #message_server_state{}, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

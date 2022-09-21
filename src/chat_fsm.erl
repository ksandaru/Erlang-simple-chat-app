%%%-------------------------------------------------------------------
%%% @author Kanishka Bandara
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(chat_fsm).

-behaviour(gen_fsm).

-export([start_link/0, idle/2, ready_to_receive/1, ready_to_send/1, message_send/2, recived_message/2]).
-export([init/1, handle_event/3,
  handle_sync_event/4, handle_info/3, terminate/3, code_change/4, send_message/2]).

-define(SERVER, ?MODULE).

-record(chat_fsm_state, {from, to , msgsent }).
%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
  gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).


init([]) ->
  io:format("starting fsm with idle state..."),
  process_flag(trap_exit, true),
  {ok, idle, #chat_fsm_state{
    from = "",
    to="",
    msgsent = ""
  }}.

ready_to_receive(Reciever)->
  gen_fsm:send_event({?MODULE, list_to_atom(Reciever)}, recieve_msg).
recieve_message(Message,Reciever)->
  gen_fsm:send_event({?MODULE,list_to_atom(Reciever)},{recieve_message, Message}).
message_send(Message, To)->
  gen_fsm:send_event({?MODULE,node()},{send, Message, To}).
ready_to_send(Reciever)->
  gen_fsm:send_event({?MODULE,node()},{msg_send,Reciever}).


idle(recieve_msg,State)->
  io:format("ready to receive!~n"),
  {next_state,recived_message,State};
idle({msg_send,Reciever},S)->
  io:format("ready to send!~n"),
  ready_to_receive(Reciever),
  {next_state, send_message, S}.
send_message({send,Message,Reciever},S)->
  io:format("Message sent!~n"),
  recieve_message(Message,Reciever),
  {next_state,idle,S}.
recived_message({recieve_message, Message},State)->
  io:format("Msg received!~n"),
  message_server:recv_msg(Message),
  {next_state, idle, State}.


handle_event(_Event, StateName, State = #chat_fsm_state{}) ->{next_state, StateName, State}.

handle_sync_event(_Event, _From, StateName, State = #chat_fsm_state{}) ->Reply = ok,
  {reply, Reply, StateName, State}.

handle_info(_Info, StateName, State = #chat_fsm_state{}) ->{next_state, StateName, State}.

terminate(_Reason, _StateName, _State = #chat_fsm_state{}) ->
  ok.

code_change(_OldVsn, StateName, State = #chat_fsm_state{}, _Extra) ->{ok, StateName, State}.
%%%===================================================================
%%% Internal functions
%%%===================================================================

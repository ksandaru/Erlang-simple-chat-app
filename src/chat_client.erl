%%%-------------------------------------------------------------------
%%% @author Kanishka Bandara
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Sep 2022 8:43 PM
%%%-------------------------------------------------------------------
-module(chat_client).
-author("Kanishka Bandara").

%% API
-export([create_chat_node/1, send_message/2, stop_conversation/0, save_user_data/4]).

create_chat_node(Username)->
  message_server:start_link(Username).

send_message(ReceiverNode,Message)->
  message_server:send_message(ReceiverNode, Message).

stop_conversation()->
  message_server:stop().

save_user_data(Nodename, Username, Location, Gender)->
  database_server:store(Nodename, Username, Location, Gender).

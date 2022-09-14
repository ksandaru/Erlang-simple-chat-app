%%%-------------------------------------------------------------------
%%% @author Kanishka Bandara
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Sep 2022 12:41 PM
%%%-------------------------------------------------------------------
-module(database_logic).
-author("Kanishka Bandara").

%% API

-export([install/1, get_db/1, get_all_dbe/1, delete_db/1, store_db/4]).
-include_lib("stdlib/include/qlc.hrl").
-record(userDetails, {node,username, location, gender}).

%%initialize database
install(Nodes) ->
  ok = mnesia:create_schema(Nodes),
  rpc:multicall(Nodes, application, start, [mnesia]),
  try
      mnesia:table_info(type,userDetails)
  catch
      exit:_  ->
        mnesia:create_table(userDetails, [{attributes, record_info(fields, userDetails)},
          {type, bag},
          {disc_copies, Nodes}])
  end.


store_db(Node, Username, Location, Gender) ->
  F = fun() ->
    mnesia:write(#userDetails{node =Node, username = Username, location = Location, gender = Gender})
      end,
  mnesia:transaction(F).

get_db(Node) ->
  F = fun() ->
    Query = qlc:q([X || X <- mnesia:table(userDetails),
      X#userDetails.node =:= Node]),
    Results = qlc:e(Query),
    lists:map(fun(Item) -> Item#userDetails.username end, Results)
      end,
  mnesia:transaction(F).

get_all_dbe(Node) ->
  F = fun() ->
    Query = qlc:q([X || X <- mnesia:table(userDetails),
      X#userDetails.node =:= Node]),
    Results = qlc:e(Query),
    lists:map(fun(Item) -> {Item#userDetails.username, Item#userDetails.location, Item#userDetails.gender} end, Results)
      end,
  mnesia:transaction(F).

delete_db(Node) ->
  F = fun() ->
    Query = qlc:q([X || X <- mnesia:table(userDetails),
      X#userDetails.node =:= Node]),
    Results = qlc:e(Query),

    FF = fun() ->
      lists:foreach(fun(Result) -> mnesia:delete_object(Result) end, Results)
         end,
    mnesia:transaction(FF)
      end,
  mnesia:transaction(F).

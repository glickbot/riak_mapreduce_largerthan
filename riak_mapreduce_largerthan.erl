-module(riak_mapreduce_largerthan).
-export([map_largerthan/3]).
-author('Jon Glick <jglick@basho.com>').

%% https://github.com/glickbot/riak_mapreduce_largerthan

%% Largly pulled from Christian Dahlqvist's work:
%%     - https://github.com/whitenode/riak_mapreduce_utils

% curl -X POST -H "content-type: application/json" -H "Accept: application/json" http://localhost:8098/mapred --data @-<<\EOF
% {"inputs":"bucketname",
% "query":[
% {"map":{"language":"erlang","module":"riak_mapreduce_largerthan","function":"map_largerthan", "keep":false, "arg":["83886080"]}}
% ]}
% EOF

map_largerthan({error, notfound}, _, _) ->
    [];
map_largerthan(RiakObject, _, [Size]) when is_binary(Size) ->
    DataSize = lists:foldl(
    	fun(V, A) -> (byte_size(V) + A) end,
    	0,
    	riak_object:get_values(RiakObject)
    ),
    case DataSize < binary_to_integer(Size) of 
		true -> [];
        false ->
        	[[
            	riak_object:bucket(RiakObject),
                riak_object:key(RiakObject),
                integer_to_binary(DataSize)
		    ]]
    end;
map_largerthan(_, _, _) ->
	[].

binary_to_integer(B) ->
    erlang:list_to_integer(erlang:binary_to_list(B)).

integer_to_binary(I) ->
	erlang:list_to_binary(erlang:integer_to_list(I)).
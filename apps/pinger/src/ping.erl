-module(ping).

-behaviour(websocket_client_handler).

-export([
         start_link/0,
         init/2,
         websocket_handle/3,
         websocket_info/3,
         websocket_terminate/3
        ]).

start_link() ->
    websocket_client:start_link("wss://localhost:8443/websocket", ?MODULE, []).

init([], _ConnState) ->
    gproc:mreg(p, l, [{bot, true}]),
    {ok, 0}.

websocket_handle({text, Msg}, _ConnState, State) ->
    io:fwrite("got Msg: ~p~n", [Msg]),
    folsom_metrics:notify(msg, erlang:system_time(milli_seconds), histogram),
    {ok, State}.
%% websocket_handle({text, Msg}, _ConnState, 5) ->
%%     {close, <<>>, 10};
%% websocket_handle({text, Msg}, _ConnState, State) ->
%%     timer:sleep(1000),
%%     BinInt = list_to_binary(integer_to_list(State)),
%%     Reply = {text, <<"hello, this is message #", BinInt/binary >>},
%%     {reply, Reply, State + 1}.

websocket_info(stop, _ConnState, State) ->
    {close, <<>>, State}.

websocket_terminate(Reason, _ConnState, State) ->
    %% io:format("Websocket closed in state ~p wih reason ~p~n",
    %%           [State, Reason]),
    ok.

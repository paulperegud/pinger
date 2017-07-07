%%%-------------------------------------------------------------------
%%% @author Paul Peregud <pawel@logi.lan>
%%% @copyright (C) 2017, Paul Peregud
%%% @doc
%%%
%%% @end
%%% Created :  2 Jul 2017 by Paul Peregud <pawel@logi.lan>
%%%-------------------------------------------------------------------
-module(pinger).

%% API
-export([start/1, stop/0]).

%%%===================================================================
%%% API
%%%===================================================================

start(N) ->
    folsom_metrics:new_histogram(msg),
    spawn(fun() -> pinger_sup:many(N) end).

stop() ->
    folsom_metrics:delete_metric(msg),
    gproc:bcast({p, l, {bot, true}}, stop).

%%%===================================================================
%%% Internal functions
%%%===================================================================

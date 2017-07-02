%%%-------------------------------------------------------------------
%% @doc pinger top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(pinger_sup).

-behaviour(supervisor).

%% API
-export([one/0, start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).
-define(CHILD(I, Type, Args), {I, {I, start_link, Args}, permanent, 5000, Type, [I]}).
-define(SIMPLE(I, Args), {undefined, {I, start_link, Args}, temporary, 5000, worker, [I]}).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

one() ->
    supervisor:start_child(?SERVER, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    Ping = ?SIMPLE(ping, []),
    {ok, { {simple_one_for_one, 0, 1}, [Ping]} }.

%%====================================================================
%% Internal functions
%%====================================================================

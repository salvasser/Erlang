%%%-------------------------------------------------------------------
%% @doc web_users public API
%% @end
%%%-------------------------------------------------------------------

-module(web_users_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    web_users_sup:start_link().

stop(_State) ->
    ok.

%% internal functions

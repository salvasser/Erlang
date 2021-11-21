-module(testfun).
-export([calc/3]).

calc(Module, Fun, Arg) ->
	apply(Module, Fun, [Arg]).

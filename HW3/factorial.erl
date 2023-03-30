#!/usr/bin/env escript
main([String]) ->
  N = list_to_integer(String),
  F = fac(N, 1),
  io:format("factorial ~w = ~w\n", [N,F]);

main(_) ->
  halt(1).

fac(0, Acc) -> Acc;
fac(N, Acc) when N > 0 -> fac(N-1, N*Acc).

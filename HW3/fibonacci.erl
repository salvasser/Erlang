-module(fibonacci).
-export([fib/1]).

fib(N) -> fib (N,0).

fib(0, Acc) -> Acc;
fib(1, Acc) -> Acc+1;
fib(N, Acc) when N>1 -> fib(N-1, Acc) + fib(N-2, Acc).

-module(tasks).
-compile([export_all]).

%%%%%%%%%%%%%%%A%%%%%%%%%%%%%%%%%%%
output(N) -> output(N, 1).
	
output(1, Acc) -> Acc;
output(N, Acc) when N>1 -> 
	io:fwrite("~p~n", [Acc]),
	output(N-1, Acc+1).


%%%%%%%%%%%%%%%B%%%%%%%%%%%%%%%%%%%
output_AB(A, A) -> A;
output_AB(A, B) when B>A -> 
	io:fwrite("~p~n", [A]),
	output_AB(A+1, B);
output_AB(A, B) when A>B ->
	io:fwrite("~p~n", [A]),
	output_AB(A-1, B).
	
%%%%%%%%%%%%%%%C%%%%%%%%%%%%%%%%%%%
akkerman(0, N) -> N+1;
akkerman(M, 0) when M>0 -> akkerman(M-1, 1);
akkerman(M, N) when M>0,N>0 -> akkerman(M-1, akkerman(M, N-1)).

%%%%%%%%%%%%%%%D%%%%%%%%%%%%%%%%%%%
two_power(1.0) -> "YES";
two_power(1) -> "YES";
two_power(N) when N>=2 -> two_power(N/2);
two_power(N) when 2>N,N>1;1>N -> "NO".

%%%%%%%%%%%%%%%E%%%%%%%%%%%%%%%%%%%
sum(N) -> sum (N, 0).

sum(0, Acc) -> Acc;
sum(N, Acc) -> sum(N-1, Acc+N).




	
	





	

	
	
	
